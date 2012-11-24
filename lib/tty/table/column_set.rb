# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class that represents table columns properties.
    class ColumnSet
      include Equatable
      extend Delegatable

      attr_reader :table

      delegatable_method :table, :column_widths

      def initialize(table)
        @table = table
      end

      # Calculate total table width
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
      def extract_widths!
        return column_widths unless column_widths.empty?

        rows     = table.to_a
        data     = table.header ? rows + [table.header] : rows
        colcount = data.max { |row_a, row_b| row_a.size <=> row_b.size }.size

        table.column_widths = find_maximas colcount, data
        self
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
      def find_maximas(colcount, data)
        maximas = []
        start   = 0

        start.upto(colcount - 1) do |index|
          maximas << find_maximum(data, index)
        end
        maximas
      end

      # Find a maximum column width.
      #
      # @param [Array] data
      #
      # @param [Integer] index
      #
      # @api private
      def find_maximum(data, index)
        data.map { |row| row[index] ? (row[index].to_s.size) : 0 }.max
      end

    end # ColumnSet
  end # Table
end # TTY
