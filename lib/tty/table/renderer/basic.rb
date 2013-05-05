# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Renderer

      # Renders table without any border styles.
      class Basic
        extend TTY::Delegatable

        # Table to be rendered
        #
        # @return [TTY::Table]
        #
        # @api public
        attr_reader :table

        # Table border to be rendered
        #
        # @return [TTY::Table::Border]
        #
        # @api private
        attr_reader :border_class

        TABLE_DELEGATED_METHODS = [:column_widths, :column_aligns]

        delegatable_method :table, *TABLE_DELEGATED_METHODS

        # Initialize and setup a Renderer
        #
        # @param [Hash] options
        #   :indent - Indent the first column by indent value
        #   :padding - Pad out the row cell by padding value
        #
        # @return [Table::Renderer::Basic]
        def initialize(options={})
          setup(options)
        end

        # Setup attributes when Renderer is invoked
        #
        # @return [self]
        #
        # @api private
        def setup(options = {})
          @padding    = 0
          @indent     = options.fetch :indent, 0
          self
        end
        private :setup

        # Sets the output padding,
        #
        # @param [Integer] value
        #   the amount of padding, not allowed to be zero
        #
        # @api public
        def padding=(value)
          @padding = [0, value].max
        end

        # @api public
        def self.render(table, options={})
          new(options).render(table)
        end

        # Renders table
        #
        # @param [TTY::Table] table
        #   the table to be rendered
        #
        # @return [String] string representation of table
        #
        # @api public
        def render(table, border_class=Border::Null)
          @table = table
          @border_class = table.border_class || border_class
          return if table.empty?

          body = []
          unless table.length.zero?
            ColumnSet.new(table).extract_widths!
            # TODO: throw an error if too many columns as compared to terminal width
            # and then change table.orientation from vertical to horizontal
            # TODO: Decide about table orientation
            body += render_header
            body += render_rows
          end
          body.compact.join("\n")
        end

        private

        # Format the header
        #
        # @return [Array[String]]
        #
        # @api private
        def render_header
          header = table.header
          if header && !header.empty?
            operations = table.operations
            operations.run_operations(:alignment, header, :column_widths => column_widths)
            border = border_class.new(header, table.border)
            [ border.top_line, border.row_line ].compact
          else
            []
          end
        end

        # Format the rows
        #
        # @return [Arrays[String]]
        #
        # @api private
        def render_rows
          operations = table.operations
          operations.run_operations(:alignment, table.to_a, :column_widths => column_widths)
          aligned = table.to_a
          first_row_border = border_class.new(aligned.first, table.border)
          aligned_border = aligned.each_with_index.map { |row, index|
            render_row(row, aligned.size != (index += 1))
          }

          [ table.header ? first_row_border.separator : first_row_border.top_line,
            aligned_border,
            first_row_border.bottom_line ].compact
        end

        # Format a single row with border
        #
        # @param [Array] row
        #   a row to decorate
        #
        # @param [Boolean] is_last_row
        #
        # @api private
        def render_row(row, is_last_row)
          border    = border_class.new(row, table.border)
          separator = border.separator
          row_line  = border.row_line

          if (table.border.separator == TTY::Table::Border::EACH_ROW) && is_last_row
            [row_line, separator]
          else
            row_line
          end
        end

      end # Basic
    end # Renderer
  end # Table
end # TTY
