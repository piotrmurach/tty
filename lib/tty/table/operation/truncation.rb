# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Operation

      # A class responsible for shortening text.
      class Truncation

        attr_reader :widths

        # Initialize a Truncation
        #
        # @api public
        def initialize(widths)
          @widths = widths
        end

        # Apply truncation to a field
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
        # @return [TTY::Table::Field]
        #
        # @api public
        def call(field, row, col)
          width       = widths[col] || field.width
          field.value = truncate(field.value, width)
        end

        # Shorten given string with traling character.
        #
        # @param [String] string
        #   the string to truncate
        # @param [Integer] width
        #   the maximum width
        #
        # @return [String]
        #
        # @api public
        def truncate(string, width)
          TTY::Text.truncate(string, width)
        end

      end # Truncation
    end # Operation
  end # Table
end # TTY
