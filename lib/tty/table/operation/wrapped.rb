# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Operation

      # A class responsible for wrapping text.
      class Wrapped
        include Operation

        # Wrap a long string according to the width.
        #
        # @param [String] string
        #   the string to wrap
        # @param [Integer] width
        #   the maximum width
        # @param [Boolean] addnewline
        #   add new line add the end
        #
        # @api public
        def wrap(string, width)
          as_unicode do
            chars = string.chars.to_a
            return string if chars.length <= width
            idx = width
            return chars[0, idx].join + "\n" + wrap(chars[idx..-1].join, width)
          end
        end

      end # Wrapped
    end # Operation
  end # Table
end # TTY

