# encoding: utf-8

module TTY
  class Coercer
    # Coerce values into float number
    #
    # @api public
    class Float
      def self.coerce(value, strict = true)
        Kernel.send(:Float, value.to_s)
      rescue
        if strict
          raise InvalidArgument, "#{value} could not be coerced into Float"
        else
          value.to_f
        end
      end
    end # Float
  end # Coercer
end # TTY
