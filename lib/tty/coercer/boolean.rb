# -*- encoding: utf-8 -*-

module TTY
  class Coercer

    # A class responsible for boolean type coercion
    class Boolean

      # Coerce value to boolean type including range of strings such as
      #
      # @param [Object] value
      #
      # @example
      #   coerce("True") # => true
      #
      #   other values coerced to true are:
      #     1, t, T, TRUE,  true,  True,  y, Y, YES, yes, Yes
      #
      #  coerce("False") # => false
      #
      #  other values coerced to false are:
      #    0, f, F, FALSE, false, False, n, N, No,  no,  No
      #
      # @api public
      def self.coerce(value)
        case value.to_s
        when %r/^(yes|y|t(rue)?|1)$/i
          return true
        when %r/^(no|n|f(alse)?|0)$/i
          return false
        else
          raise TypeError, "Expected boolean type, got #{value}"
        end
      end

    end # Boolean

  end # Coercer
end # TTY
