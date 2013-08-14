# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Operation

      # A class responsible for padding field with whitespace
      class Padding

        attr_reader :padding_top

        attr_reader :padding_right

        attr_reader :padding_bottom

        attr_reader :padding_left

        attr_reader :padding_width

        # Initialize a Padding operation
        #
        # @param [TTY::Table::Padder]
        #
        # @api public
        def initialize(padding)
          @padding_top    = "\n" * padding.top
          @padding_right  = ' '  * padding.right
          @padding_bottom = "\n" * padding.bottom
          @padding_left   = ' '  * padding.left
          @padding_width  = padding.left + padding.right
        end

        # Apply padding to a field
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
          text = field.value.to_s
          text = text.slice!(0...(text.size - padding_width))
          text.insert(0, padding_left).insert(-1, padding_right)
          text.insert(0, padding_top).insert(-1, padding_bottom)

          field.value = text
        end

      end # Padding
    end # Operation
  end # Table
end # TTY
