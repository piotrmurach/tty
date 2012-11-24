# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Operation

      # A class which responsiblity is to align table rows and header.
      class AlignmentSet < Vector

        # Lookup an alignment by index
        #
        # @param [Integer]
        #
        # @return [Symbol] alignment
        #
        # @api public
        def [](index)
          elements.fetch(index, :left)
        end

        # Return each alignment in an Array
        #
        # @return [Array]
        #
        # @api private
        def alignments
          map { |alignment| alignment }
        end

        # Align table header
        #
        # @return [Array[String]]
        #
        # @api public
        def align_header(header, options={})
          align_row(header, options)
        end

        # Align the supplied rows with the correct alignment.
        #
        # @param [Array] rows
        #
        # @return [Array[Array]]
        #   the aligned rows
        #
        # @api private
        def align_rows(rows, options={})
          rows.map { |row| align_row(row, options) }
        end

      private

        # Align each cell in a row
        #
        # @param [Object] row
        #
        # @param [Hash] options
        #
        # @return [Array[String]]
        #
        # @api private
        def align_row(row, options={})
          line = []
          row.each_with_index do |cell, index|
            column_width = options[:column_widths][index]
            alignment = Alignment.new self[index]

            if index == row.size - 1
              line << alignment.format(cell, column_width)
            else
              line << alignment.format(cell, column_width, ' ')
            end
          end
          line
        end

      end # AlignmentSet
    end # Operation
  end # Table
end # TTY
