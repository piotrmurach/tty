# -*- encoding: utf-8 -*-

module TTY
  class Table
    module Operation

      # A class responsible for shortening text.
      class Truncation

        # Shorten given string with traling character.
        #
        # @param [String] string
        #   the string to truncate
        # @param [Integer] width
        #   the maximum width
        # @param [String] trailing
        #   the trailing character
        #
        # @return [String]
        #
        # @api public
        def truncate(string, width, trailing = '…')
          as_unicode do
            chars = string.chars.to_a
            if chars.length < width
              chars.join
            else
              traling_size = trailing.chars.to_a.size
              ( chars[0, width - traling_size].join ) + trailing
            end
          end
        end

        if "".respond_to?(:encode)
          def as_unicode
            yield
          end
        else
          def as_unicode
            old, $KCODE = $KCODE, "U"
            yield
          ensure
            $KCODE = old
          end
        end

      end # Truncation
    end # Operation
  end # Table
end # TTY
