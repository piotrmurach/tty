# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Validatable

      MIN_CELL_WIDTH = 3.freeze

      # Check if table rows are the equal size
      #
      # @raise [DimensionMismatchError]
      #   if the rows are not equal length
      #
      # @return [nil]
      #
      # @api private
      def assert_row_sizes(rows)
        size = (rows[0] || []).size
        rows.each do |row|
          if not row.size == size
            raise TTY::Table::DimensionMismatchError, "row size differs (#{row.size} should be #{size})"
          end
        end
      end

      def assert_matching_widths(rows)
      end

      def assert_string_values(rows)
      end

    end # Validatable
  end # Table
end # TTY
