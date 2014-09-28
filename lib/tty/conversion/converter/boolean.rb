# encoding: utf-8

module TTY
  module Conversion
    class BooleanConverter

      attr_reader :target

      attr_reader :source

      def initialize(source = String)
        @source = source
        @target = [TrueClass, FalseClass]
      end

      def boolean?(value)
        target.any? { |klass| value.is_a?(klass) }
      end

      # Convert value to boolean type including range of strings such as
      #
      # @param [Object] value
      #
      # @example
      #   coerce("True") # => true
      #
      #   other values coerced to true are:
      #     1, t, T, TRUE,  true,  True,  y, Y, YES, yes, Yes
      #
      # @example
      #   coerce("False") # => false
      #
      #  other values coerced to false are:
      #    0, f, F, FALSE, false, False, n, N, No,  no,  No
      #
      # @api public
      def convert(value)
        case value.to_s
        when /^(yes|y|t(rue)?|1)$/i
          return true
        when /^(no|n|f(alse)?|0)$/i
          return false
        else
          fail TypeError, "Expected boolean type, got #{value}"
        end
      end
    end # BooleanConverter
  end # Conversion
end # TTY
