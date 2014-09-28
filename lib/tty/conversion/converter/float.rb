# encoding: utf-8

module TTY
  module Conversion
    class FloatConverter

      attr_reader :target

      attr_reader :source

      def initialize(source = String)
        @source = source
        @target = Float
      end

      # @api public
      def convert(value, strict = false)
        Kernel.send(target.name.to_sym, value.to_s)
      rescue
        if strict
          raise InvalidArgument, "#{value} could not be coerced into #{target.name}"
        else
          value.to_f
        end
      end
    end # IntegerConverter
  end # Conversion
end # TTY
