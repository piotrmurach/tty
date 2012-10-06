# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Renderer
      class Basic

        attr_reader :padding

        attr_reader :indent

        attr_reader :column_widths

        attr_reader :rows

        # @param [Hash] options
        #   :indent - Indent the first column by indent value
        #   :padding - Pad out the row cell by padding value
        #   :col_widths - Enforce particular column width values
        #
        # @return [Table::Renderer::Basic]
        def initialize(options={})
          @padding    = 0
          @indent     = options.fetch :indent, 0
          @column_widths = []
          @column_aligns = options.fetch :column_aligns, []
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

        # Renders table
        #
        # @param [Enumerable] rows
        #   the table rows
        #
        # @return [String] string representation of table
        #
        # @api public
        def render(rows, options={})
          return if rows.empty?
          # TODO: Decide about table orientation
          @rows = rows
          body = []
          unless rows.length.zero?
            extract_column_widths(rows)
            body += render_rows
          end
          body.join("\n")
        end

        # Calcualte total table width
        #
        # @return [Integer]
        #
        # @api public
        def total_width
          column_widths.reduce(:+)
        end

        # Calcualte maximum column widths
        #
        # @return [Array] column widths
        #
        # @api private
        def extract_column_widths(rows)
          # TODO: throw an error if too many columns as compared to terminal width
          colcount = rows.max{ |a,b| a.size <=> b.size }.size
          maximas = []
          start = 0

          start.upto(colcount - 1) do |index|
            maximum = rows.map { |row|
              row[index] ? (row[index].to_s.size) : 0
            }.max
            maximas << maximum
          end
          @column_widths = maximas
        end

        # Adjust the rows to maximum widths
        #
        # @return [Arrays[String]]
        #
        # @api private
        def render_rows
          rows.map do |row|
            line = ""
            row.each_with_index do |column, index|
              column_width = column_widths[index]
              if index == row.size - 1
                line <<  "%-#{column_width}s" % column.to_s
              else
                line << "%-#{column_width}s " % column.to_s
              end
            end
            line
          end
        end

      end # Basic
    end # Renderer
  end # Table
end # TTY
