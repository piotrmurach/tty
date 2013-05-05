# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Operation

      # A class responsible for shortening text.
      class Truncation

        # Apply truncation to a row
        #
        # @param [Array] row
        #   the table row
        #
        # @return [Array[String]]
        #
        # @api public
        def call(row, options={})
          index = 0
          row.map! do |field|
            width = options.fetch(:column_widths, {})[index] || field.width
            index += 1
            field.value = truncate(field.value, width)
          end
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
