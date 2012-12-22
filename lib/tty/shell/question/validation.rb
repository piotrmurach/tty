# -*- encoding: utf-8 -*-

module TTY
  class Shell
    class Question

      # A class representing question validation.
      class Validation

        # @api private
        attr_reader :validation
        private :validation

        # Initialize a Validation
        #
        # @param [Object] validation
        #
        # @return [undefined]
        #
        # @api private
        def initialize(validation=nil)
          @validation = validation ? coerce(validation) : validation
        end

        # Convert validation into known type.
        #
        # @param [Object] validation
        #
        # @api private
        def coerce(validation)
          case validation
          when Proc
            validation
          when Regexp, String
            Regexp.new(validation.to_s)
          else
            raise TTY::ValidationCoercion, "Wrong type, got #{validation.class}"
          end
        end

        # Check if validation is required
        #
        # @return [Boolean]
        #
        # @api public
        def validate?
          !!validation
        end

        # Test if the value matches the validation
        #
        # @example
        #   validation.valid_value?(value) # => true or false
        #
        # @param [Object] value
        #  the value to validate
        #
        # @return [undefined]
        #
        # @api public
        def valid_value?(value)
          check_validation(value)
        end

        private

        # Check if provided value passes validation
        #
        # @param [String] value
        #
        # @return [undefined]
        #
        # @api private
        def check_validation(value)
          if validate? && value
            value = value.to_s
            if validation.is_a?(Regexp) && validation =~ value
            elsif validation.is_a?(Proc) && validation.call(value)
            else raise TTY::InvalidArgument, "Invalid input for #{value}"
            end
          end
        end

      end # Validation
    end # Question
  end # Shell
end # TTY
