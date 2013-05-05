# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Operation

      # A class responsible for wrapping text.
      class Wrapped

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
            field.value = wrap(field.value, width)
          end
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

