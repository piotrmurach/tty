# encoding: utf-8

module TTY
  # A mixin to allow instances conversion to array type
  #
  # @api public
  module Conversion
    # Converts the object into an Array. If copy is set to true
    # a copy of object will be made.
    #
    # @param [Object] object
    #
    # @param [Boolean] copy
    #
    # @return [Array]
    #
    # @api private
    def convert_to_array(object, copy = false)
      case object
      when Array
        copy ? object.dup : object
      when Hash
        Array(object)
      else
        begin
          converted = object.to_ary
        rescue Exception => e
          raise TTY::TypeError,
                "Cannot convert #{object.class} into an Array (#{e.message})"
        end
        converted
      end
    end
  end # Conversion
end # TTY
