# encoding: utf-8

module TTY
  class Table
    # A class that represents table column properties.
    #
    # Used by {Table} to manage column sizing.
    #
    # @api private
    class ColumnSet
      include Equatable

      attr_reader :table

      # Initialize a ColumnSet
      #
      # @api public
      def initialize(table)
        @table = table
      end

      # Calculate total table width
      #
      # @return [Integer]
      #
      # @api public
      def total_width
        extract_widths.reduce(:+)
      end

      # Calcualte maximum column widths
      #
      # @return [Array] column widths
      #
      # @api private
      def extract_widths
        data     = table.data
        colcount = data.max { |row_a, row_b| row_a.size <=> row_b.size }.size

        self.class.find_maximas(colcount, data)
      end

      # Assert data integrity for column widths
      #
      # @param [Array] column_widths
      #
      # @param [Integer] table_widths
      #
      # @raise [TTY::InvalidArgument]
      #
      # @api public
      def self.assert_widths(column_widths, table_widths)
        if column_widths.empty?
          fail InvalidArgument, 'Value for :column_widths must be ' \
                                 'a non-empty array'
        end
        if column_widths.size != table_widths
          fail InvalidArgument, 'Value for :column_widths must match ' \
                                 'table column count'
        end
      end

      # Converts column widths to array format or infers default widths
      #
      # @param [TTY::Table] table
      #
      # @param [Array, Numeric, NilClass] column_widths
      #
      # @return [Array[Integer]]
      #
      # @api public
      def self.widths_from(table, column_widths = nil)
        case column_widths
        when Array
          assert_widths(column_widths, table.column_size)
          Array(column_widths).map(&:to_i)
        when Numeric
          Array.new(table.column_size, column_widths)
        when NilClass
          new(table).extract_widths
        else
          fail TypeError, 'Invalid type for column widths'
        end
      end

      private

      # Find maximum widths for each row and header if present.
      #
      # @param [Integer] colcount
      #   number of columns
      # @param [Array[Array]] data
      #   the table's header and rows
      #
      # @api private
      def self.find_maximas(colcount, data)
        maximas = []
        start   = 0

        start.upto(colcount - 1) do |col_index|
          maximas << find_maximum(data, col_index)
        end
        maximas
      end

      # Find a maximum column width. The calculation takes into account
      # wether the content is escaped or not.
      #
      # @param [Array] data
      #   the table data
      #
      # @param [Integer] index
      #   the column index
      #
      # @api private
      def self.find_maximum(data, index)
        data.map { |row| (value = row.call(index)) ? value.length : 0 }.max
      end
    end # ColumnSet
  end # Table
end # TTY
