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

      # Check if options are of required type
      #
      # @api private
      def validate_options!(options)
        if (header = options[:header]) &&
           (!header.kind_of?(Array) || header.empty?)
          raise InvalidArgument, ":header must be a non-empty array"
        end

        if (rows = options[:rows]) &&
          !(rows.kind_of?(Array) || rows.kind_of?(Hash))
          raise InvalidArgument, ":rows must be a non-empty array or hash"
        end
      end

    end # Validatable
  end # Table
end # TTY
