# encoding: utf-8

module TTY
  # A mixin to coerce a value into a specific class.
  module Coercion
    # Helper to coerce value into a specific class.
    #
    # @param [Object] object
    #
    # @param [Class] cls
    #
    # @param [Symbol] method
    #
    # @api public
    def coerce_to(object, cls, method)
      return object if object.is_a?(cls)

      begin
        result = object.__send__(method)
      rescue Exception => e
        raise TypeError, "Coercion error #{e.message}"
      end
      unless result.is_a?(cls)
        fail TypeError, "Coercion error: obj.#{method} did not return " \
                        "a #{cls} (was #{result.class})"
      end
      result
    end
  end # Coercion
end # TTY
