# encoding: utf-8

module TTY
  class Coercer
    # Coerce value into integer number
    #
    # @api public
    class Integer
      def self.coerce(value, strict = true)
        Kernel.send(:Integer, value.to_s)
      rescue
        if strict
          raise InvalidArgument, "#{value} could not be coerced into Integer"
        else
          value.to_i
        end
      end
    end # Integer
  end # Coercer
end # TTY
