# -*- encoding: utf-8 -*-

require 'tty/table/validatable'

module TTY
  class Table
    class Renderer

      # Renders table without any border styles.
      class Basic
        include TTY::Table::Validatable

        # Table to be rendered
        #
        # @return [TTY::Table]
        #
        # @api public
        attr_reader :table
        private :table

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
        attr_accessor :column_widths

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

        # Initialize a Renderer
        #
        # @param [Hash] options
        # @option options [String] :column_aligns
        #   used to format table individual column alignment
        # @option options [String] :column_widths
        #   used to format table individula column width
        # @option options [Integer] :indent
        #   indent the first column by indent value
        #
        #   :padding - Pad out the row cell by padding value
        #
        # @return [TTY::Table::Renderer::Basic]
        #
        # @api private
        def initialize(table, options={})
          @table         = table || (raise ArgumentRequired, "Expected TTY::Table instance, got #{table.inspect}")
          @multiline     = options.fetch(:multiline) { false }
          @operations    = TTY::Table::Operations.new(table)
          unless multiline
            @operations.add_operation(:escape, Operation::Escape.new)
            @operations.run_operations(:escape)
          end
          @border        = TTY::Table::BorderOptions.from(options.delete(:border))
          @column_widths = ColumnSet.widths_from(table, options.fetch(:column_widths, nil))
          @column_aligns = Array(options.delete(:column_aligns)).map(&:to_sym)
          @filter        = options.fetch(:filter) { proc { |val, row, col| val } }
          @width         = options.fetch(:width) { TTY.terminal.width }
          @border_class  = options.fetch(:border_class) { Border::Null }
          @indent        = options.fetch(:indent) { 0 }
        end

        # Store border characters, style and separator for the table rendering
        #
        # @param [Hash, BorderOptions] options
        #
        # @yield [] block representing border options
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
          operations.add_operation(:alignment, Operation::AlignmentSet.new(column_aligns, column_widths))
          operations.add_operation(:filter, Operation::Filter.new(filter))
          operations.add_operation(:truncation, Operation::Truncation.new(column_widths))
          operations.add_operation(:wrapping, Operation::Wrapped.new(column_widths))
        end

        # Create indentation
        #
        # @api public
        def indentation
          ' ' * indent
        end

        # Insert indentation into a table renderd line
        #
        # @param [#to_a, #to_s] line
        #   the rendered table line
        #
        # @api public
        def insert_indentation(line)
          line = line.is_a?(Array) ? line[0] : line
          line.insert(0, indentation) if line
        end

        # Return a table part with indentation inserted
        #
        # @param [#map, #to_s] part
        #   the rendered table part
        #
        # @api public
        def insert_indent(part)
          if part.respond_to?(:to_a)
            part.map { |line| insert_indentation(line) }
          else
            insert_indentation(part)
          end
        end

        # Sets the output padding,
        #
        # @param [Integer] value
        #   the amount of padding, not allowed to be zero
        #
        # @api public
        def padding=(value)
          @padding = [0, value].max
        end

        # Renders table
        #
        # @return [String] string representation of table
        #
        # @api public
        def render
          return if table.empty?

          # TODO: throw an error if too many columns as compared to terminal width
          # and then change table.orientation from vertical to horizontal
          # TODO: Decide about table orientation
          add_operations
          ops = [:filter, :alignment]
          multiline ? ops << :wrapping : ops << :truncation
          operations.run_operations(*ops)
          render_data.compact.join("\n")
        end

        private

        # Render table data
        #
        # @api private
        def render_data
          first_row   = table.first
          data_border = border_class.new(column_widths, border)
          header      = render_header(first_row, data_border)
          rows_with_border = render_rows(data_border)
          bottom_line = if result = data_border.bottom_line
            result.insert(0, indentation)
          else
            result
          end

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
            header = [top_line, data_border.row_line(row), data_border.separator].compact
            header.map! { |e|
              e = e.is_a?(Array) ? e[0] : e
              e.insert(0, indentation) if e
            }
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
          rows   = table.rows
          size   = rows.size
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
            [row_line, separator]
          else
            row_line.insert(0, indentation)
          end
        end

      end # Basic
    end # Renderer
  end # Table
end # TTY
