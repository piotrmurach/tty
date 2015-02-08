# encoding: utf-8

module TTY
  class Table
    module Operation
      # A class which responsiblity is to align table rows and header.
      class AlignmentSet
        include Enumerable
        # Initialize an AlignmentSet
        #
        # @api private
        def initialize(aligns, widths = nil)
          @converter = Necromancer.new
          @elements = @converter.convert(aligns).to(:array)
          @widths   = widths
        end

        # Iterate over each element in the alignment set
        #
        # @example
        #   alignment = AlignmentSet.new [1,2,3]
        #   alignment.each { |element| ... }
        #
        # @return [self]
        #
        # @api public
        def each
          return to_enum unless block_given?
          to_ary.each { |element| yield element }
          self
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

        # Convert to array
        #
        #  @return [Array]
        #
        # @api public
        def to_ary
          @elements
        end

        protected

        attr_reader :widths

        attr_reader :elements

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
          direction    = field.align || self[col]
          field.value = Verse.align(field.to_s, column_width, direction)
        end
      end # AlignmentSet
    end # Operation
  end # Table
end # TTY
