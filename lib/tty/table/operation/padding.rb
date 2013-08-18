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
          text      = field.value.to_s
          multiline = !!text.index(/[\n\r]/)

          text = multiline ?  pad_multi_line(text) : pad_single_line(text)
          text.insert(0, padding_top).insert(-1, padding_bottom)

          field.value = text
        end

        # Apply padding to multi line text
        #
        # @param [String] text
        #
        # @return [String]
        #
        # @api private
        def pad_multi_line(text)
          text.split("\n", -1).map { |part| pad_around(part) }.join("\n")
        end

        # Apply padding to single line text
        #
        # @param [String] text
        #
        # @return [String]
        #
        # @api private
        def pad_single_line(text)
          pad_around(text.slice!(0...(text.size - padding_width)))
        end

        # Apply padding to left and right side of string
        #
        # @param [String] text
        #
        # @return [String]
        #
        # @api private
        def pad_around(text)
          text.insert(0, padding_left).insert(-1, padding_right)
        end

      end # Padding
    end # Operation
  end # Table
end # TTY
