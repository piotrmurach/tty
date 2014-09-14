# encoding: utf-8

module TTY
  class Table
    module Operation
      # A class which responsiblity is to align table rows and header.
      class AlignmentSet < Vector

        attr_reader :widths

        # Initialize an AlignmentSet
        #
        # @api private
        def initialize(aligns, widths = nil)
          @elements = convert_to_array(aligns)
          @widths   = widths
        end

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

        # Evaluate alignment of the provided row
        #
        # @param [Array] row
        #  the table row
        # @param [Hash] options
        #  the table options
        #
        # @return [TTY::Table::Field]
        #
        # @api public
        def call(field, row, col)
          align_field(field, col)
        end

        private

        # Align each field in a row
        #
        # @param [TTY::Table::Field] field
        #   the table field
        #
        # @param [Integer] col
        #   the table column index
        #
        # @param [Hash] options
        #
        # @return [TTY::Table::Field]
        #
        # @api private
        def align_field(field, col)
          column_width = widths[col]
          alignment    = Alignment.new(field.align || self[col])
          field.value  = alignment.format(field, column_width)
        end
      end # AlignmentSet
    end # Operation
  end # Table
end # TTY
