# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Operation

      # A class responsible for wrapping text.
      class Wrapped

        attr_reader :widths

        # Initialize a Wrapped
        #
        # @api public
        def initialize(widths)
          @widths = widths
        end

        # Apply wrapping to a field
        #
        # @param [TTY::Table::Field] field
        #   the table field
        #
        # @param [Integer] row
        #   the field row index
        #
        # @param [Integer] col
        #   the field column index
        #
        # @return [Array[String]]
        #
        # @api public
        def call(field, row, col)
          width = widths[col] || field.width
          field.value = wrap(field.value, width)
        end

        # Wrap a long string according to the width.
        #
        # @param [String] string
        #   the string to wrap
        # @param [Integer] width
        #   the maximum width
        #
        # @return [String]
        #
        # @api public
        def wrap(string, width)
          TTY::Text.wrap(string, width)
        end

      end # Wrapped
    end # Operation
  end # Table
end # TTY

