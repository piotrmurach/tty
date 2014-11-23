# encoding: utf-8

require 'tty/table/validatable'

module TTY
  class Table
    class Renderer
      # Renders table without any border styles.
      #
      # @api private
      class Basic
        include TTY::Table::Validatable

        # Table to be rendered
        #
        # @return [TTY::Table]
        #
        # @api public
        attr_reader :table
        # private :table

        # Table border to be rendered
        #
        # @return [TTY::Table::Border]
        #
        # @api private
        attr_accessor :border_class

        # The table enforced column widths
        #
        # @return [Array]
        #
        # @api public
        attr_writer :column_widths

        # The table column alignments
        #
        # @return [Array]
        #
        # @api private
        attr_accessor :column_aligns

        # The table operations applied to rows
        #
        # @api public
        attr_reader :operations

        # A callable object used for formatting field content
        #
        # @api public
        attr_accessor :filter

        # The table column span behaviour. When true the column's line breaks
        # cause the column to span multiple rows. By default set to false.
        #
        # @return [Boolean]
        #
        # @api public
        attr_accessor :multiline

        # The table indentation value
        #
        # @return [Integer]
        #
        # @api public
        attr_accessor :indent

        # The table totabl width
        #
        # @return [Integer]
        #
        # @api public
        attr_accessor :width

        # The table resizing behaviour. If true the algorithm will
        # automatically expand or shrink table to fit the terminal
        # width or specified width. By default its false.
        #
        # @return [Integer]
        #
        # @api public
        attr_accessor :resize

        # The table padding settings
        #
        # @return [TTY::Table::Padder]
        #
        # @api public
        attr_reader :padding

        # Initialize a Renderer
        #
        # @param [Hash] options
        # @option options [String] :column_aligns
        #   used to format table individual column alignment
        # @option options [String] :column_widths
        #   used to format table individula column width
        # @option options [Integer] :indent
        #   indent the first column by indent value
        # @option options [Integer,Array] :padding
        #   add padding to table fields
        #
        # @return [TTY::Table::Renderer::Basic]
        #
        # @api private
        def initialize(table, options = {})
          @table         = assert_table_type(table)
          @multiline     = options.fetch(:multiline) { false }
          @operations    = TTY::Table::Operations.new(table)
          @operations.add(:escape, Operation::Escape.new)
          @border        = TTY::Table::BorderOptions.from(options.delete(:border))
          @column_widths = options.fetch(:column_widths, nil)
          @column_aligns = Array(options.delete(:column_aligns)).map(&:to_sym)
          @filter        = options.fetch(:filter) { proc { |val, _| val } }
          @width         = options.fetch(:width) { TTY::Screen.width }
          @border_class  = options.fetch(:border_class) { Border::Null }
          @indent        = options.fetch(:indent) { 0 }
          @resize        = options.fetch(:resize) { false }
          @padding       = TTY::Table::Padder.parse(options[:padding])
        end

        # Parses supplied column widths, if not present
        # calculates natural widths.
        #
        # @return [Array[Integer]]
        #
        # @api public
        def column_widths
          @column_widths = ColumnSet.widths_from(table, @column_widths)
        end

        # Store border characters, style and separator for the table rendering
        #
        # @param [Hash, Table::BorderOptions] options
        #
        # @yield [Table::BorderOptions]
        #   block representing border options
        #
        # @api public
        def border(options=(not_set=true), &block)
          @border = TTY::Table::BorderOptions.new unless @border
          if block_given?
            border_dsl = TTY::Table::BorderDSL.new(&block)
            @border = border_dsl.options
          elsif !not_set
            @border = TTY::Table::BorderOptions.from(options)
          end
          @border
        end

        # Initialize and add operations
        #
        # @api private
        def add_operations
          operations.add(:alignment,  Operation::AlignmentSet.new(column_aligns,
                                                                  column_widths))
          operations.add(:filter,     Operation::Filter.new(filter))
          operations.add(:truncation, Operation::Truncation.new(column_widths))
          operations.add(:wrapping,   Operation::Wrapped.new(column_widths, padding))
          operations.add(:padding,    Operation::Padding.new(padding, multiline))
        end

        # Initializes indentation
        #
        # @return [TTY::Table::Indentation]
        #
        # @api private
        def indentation
          @indentation ||= TTY::Table::Indentation.new(self)
        end

        # Delegate indentation insertion
        #
        # @api public
        def insert_indent(line)
          indentation.insert_indent(line)
        end

        # Return column contraints
        #
        # @api private
        def columns_constraints
          TTY::Table::Columns.new(self)
        end

        # Sets the output padding,
        #
        # @param [Integer] value
        #   the amount of padding, not allowed to be zero
        #
        # @api public
        def padding=(value)
          @padding = TTY::Table::Padder.parse(value)
        end

        # Renders table
        #
        # @return [String] string representation of table
        #
        # @api public
        def render
          return if table.empty?

          operations.run_operations(:escape) unless multiline
          columns_constraints.enforce
          add_operations
          ops = [:alignment]
          ops << :padding unless padding.empty?
          multiline ? ops << :wrapping : ops << :truncation
          ops << :filter
          operations.run_operations(*ops)

          render_data.compact.join("\n")
        end

        private

        # Render table data
        #
        # @api private
        def render_data
          first_row        = table.first
          data_border      = border_class.new(column_widths, border)
          header           = render_header(first_row, data_border)
          rows_with_border = render_rows(data_border)
          bottom_line      = data_border.bottom_line

          insert_indent(bottom_line) if bottom_line

          [header, rows_with_border, bottom_line].compact
        end

        # Format the header if present
        #
        # @param [TTY::Table::Row, TTY::Table::Header] row
        #   the first row in the table
        #
        # @param [TTY::Table::Border] data_boder
        #   the border for this table
        #
        # @return [String]
        #
        # @api private
        def render_header(row, data_border)
          top_line = data_border.top_line
          if row.is_a?(TTY::Table::Header)
            header = [top_line, data_border.row_line(row), data_border.separator]
            insert_indent(header.compact)
          else
            top_line
          end
        end

        # Format the rows
        #
        # @param [TTY::Table::Border] data_boder
        #   the border for this table
        #
        # @return [Arrays[String]]
        #
        # @api private
        def render_rows(data_border)
          rows = table.rows
          size = rows.size
          rows.each_with_index.map do |row, index|
            render_row(row, data_border, size != (index += 1))
          end
        end

        # Format a single row with border
        #
        # @param [Array] row
        #   a row to decorate
        #
        # @param [TTY::Table::Border] data_boder
        #   the border for this table
        #
        # @param [Boolean] is_last_row
        #
        # @api private
        def render_row(row, data_border, is_last_row)
          separator = data_border.separator
          row_line  = data_border.row_line(row)

          if (border.separator == TTY::Table::Border::EACH_ROW) && is_last_row
            insert_indent([row_line, separator])
          else
            insert_indent(row_line)
          end
        end
      end # Basic
    end # Renderer
  end # Table
end # TTY
