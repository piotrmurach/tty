# -*- encoding: utf-8 -*-

module TTY
  class Table

    # A class that represents table columns properties.
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
        data.map { |row| (value=row.call(index)) ? value.length : 0 }.max
      end

    end # ColumnSet
  end # Table
end # TTY
