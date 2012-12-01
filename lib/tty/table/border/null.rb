# -*- encoding: utf-8 -*-

module TTY
  class Table
    class Border

      # A class that represents no border.
      class Null < Border

        # @api private
        def initialize(row)
          @row = row
          @widths = row.map { |cell| cell.chars.to_a.size }
        end

        def top_line
          nil
        end

        def separator
          nil
        end

        def row_line
          row.join
        end

        def bottom_line
          nil
        end

      end # Null
    end # Border
  end # Table
end # TTY
