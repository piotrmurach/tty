# -*- encoding: utf-8 -*-

module TTY
  # A class responsible for shell prompt interactions.
  class Shell

    # A class representing a question.
    class Response

      class Boolean

        def self.coerce(value)
          case value.to_s
          when %r/^(yes|y)$/i
            return true
          when %r/^(no|n)$/i
            return false
          else
            raise TypeError, "Expected boolean type, got #{value}"
          end
        end

      end # Boolean

    end # Response
  end # Shell
end # TTY
