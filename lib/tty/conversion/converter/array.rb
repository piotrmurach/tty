# encoding: utf-8

module TTY
  module Conversion
    class ArrayConverter

      attr_reader :target

      attr_reader :source

      def initialize(source = String)
        @source = source
        @target = Array
      end

      # @api public
      def convert(value, copy = false)
        case value
        when Array
          copy ? value.dup : value
        when Hash
          Array(value)
        else
          begin
            converted = value.to_ary
          rescue Exception => e
            raise TTY::TypeError,
                  "Cannot convert #{value.class} into an Array (#{e.message})"
          end
          converted
        end
      end
    end # ArrayConverter
  end # Conversion
end # TTY
