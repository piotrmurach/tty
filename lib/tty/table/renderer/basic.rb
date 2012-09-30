# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Renderer
      class Basic

        attr_reader :padding

        attr_reader :indent

        # @param [Hash] options
        #   :indent - Indent the first column by indent value
        #   :padding - Pad out the row cell by padding value
        #   :col_widths - Enforce particular column width values
        #
        # @return [Table::Renderer::Basic]
        def initialize(options={})
          @padding    = options.fetch :padding, 0
          @indent     = options.fetch :indent, 0
          @col_widths = options.fetch :col_widths, []
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

        # @api public
        def self.render(rows, options={})
          new(options).render(rows)
        end

        # @api private
        def extract_column_widths
          # TODO Calculate column widths if none provided
          # throw an error if too many columns as compared to terminal width
        end

        # Renders table
        #
        # @param [Enumerable] rows
        #   the table rows
        #
        # @return [String] string representation of table
        #
        # @api public
        def render(rows)
          return if rows.empty?

          body = []
          unless rows.length.zero?
            rows.each do |row|
              line = ""
              row.each_with_index do |column, index|
                if index == row.size - 1
                  line << "#{column.to_s}"
                else
                  line << "#{column.to_s} "
                end
              end
              body << line
            end
          end
          body.join("\n")
        end

      end # Basic
    end # Renderer
  end # Table
end # TTY
