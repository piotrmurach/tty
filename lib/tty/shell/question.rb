# encoding: utf-8

require 'date'

module TTY
  # A class responsible for shell prompt interactions.
  class Shell
    # A class representing a command line question
    class Question
      include TTY::Shell::ResponseDelegation

      PREFIX          = ' + '
      MULTIPLE_PREFIX = '   * '
      ERROR_PREFIX    = '  ERROR:'

      # Store statement.
      #
      # @api private
      attr_accessor :statement

      # Store default value.
      #
      # @api private
      attr_reader :default_value

      attr_reader :required
      private :required

      attr_reader :validation

      # Controls character processing of the answer
      #
      # @api public
      attr_reader :modifier

      # Returns valid answers
      #
      # @api public
      attr_reader :valid_values

      attr_reader :error

      # Returns echo mode
      #
      # @api public
      attr_reader :echo

      # Returns character mask
      #
      # @api public
      attr_reader :mask

      # Returns character mode
      #
      # @api public
      attr_reader :character

      # @api private
      attr_reader :shell
      private :shell

      # Initialize a Question
      #
      # @api public
      def initialize(shell, options = {})
        @shell         = shell || Shell.new
        @required      = options.fetch(:required) { false }
        @echo          = options.fetch(:echo) { true }
        @mask          = options.fetch(:mask) { false  }
        @character     = options.fetch(:character) { false }
        @in            = options.fetch(:in) { false }
        @modifier      = Modifier.new options.fetch(:modifier) { [] }
        @valid_values  = options.fetch(:valid) { [] }
        @validation    = Validation.new options.fetch(:validation) { nil }
        @default_value = nil
      end

      # Set a new prompt
      #
      # @param [String] message
      #
      # @return [self]
      #
      # @api public
      def prompt(message)
        self.statement = message
        shell.say shell.prefix + statement
        self
      end

      # Set default value.
      #
      # @api public
      def default(value)
        return self if value == ''
        @default_value = value
        self
      end

      # Check if default value is set
      #
      # @return [Boolean]
      #
      # @api public
      def default?
        !!@default_value
      end

      # Ensure that passed argument is present if required option
      #
      # @return [Question]
      #
      # @api public
      def argument(value)
        case value
        when :required
          @required = true
        when :optional
          @required = false
        end
        self
      end

      # Check if required argument present.
      #
      # @return [Boolean]
      #
      # @api private
      def required?
        required
      end

      # Set validation rule for an argument
      #
      # @param [Object] value
      #
      # @return [Question]
      #
      # @api public
      def validate(value = nil, &block)
        @validation = Validation.new(value || block)
        self
      end

      # Set expected values
      #
      # @param [Array] values
      #
      # @return [self]
      #
      # @api public
      def valid(values)
        @valid_values = values
        self
      end

      # Reset question object.
      #
      # @api public
      def clean
        @statement     = nil
        @default_value = nil
        @required      = false
        @modifier      = nil
      end

      # Modify string according to the rule given.
      #
      # @param [Symbol] rule
      #
      # @api public
      def modify(*rules)
        @modifier = Modifier.new(*rules)
        self
      end

      # Setup behaviour when error(s) occur
      #
      # @api public
      def on_error(action = nil)
        @error = action
        self
      end

      # Check if error behaviour is set
      #
      # @api public
      def error?
        !!@error
      end

      # Turn terminal echo on or off. This is used to secure the display so
      # that the entered characters are not echoed back to the screen.
      #
      # @api public
      def echo(value = nil)
        return @echo if value.nil?
        @echo = value
        self
      end

      # Chec if echo is set
      #
      # @api public
      def echo?
        !!@echo
      end

      # Set character for masking the STDIN input
      #
      # @param [String] character
      #
      # @return [self]
      #
      # @api public
      def mask(char = nil)
        return @mask if char.nil?
        @mask = char
        self
      end

      # Check if character mask is set
      #
      # @return [Boolean]
      #
      # @api public
      def mask?
        !!@mask
      end

      # Set if the input is character based or not
      #
      # @param [Boolean] value
      #
      # @return [self]
      #
      # @api public
      def char(value = nil)
        return @character if value.nil?
        @character = value
        self
      end

      # Check if character intput is set
      #
      # @return [Boolean]
      #
      # @api public
      def character?
        !!@character
      end

      # Set expect range of values
      #
      # @param [String] value
      #
      # @api public
      def in(value = nil)
        return @in if value.nil?
        @in = TTY::Coercer::Range.coerce value
        self
      end

      # Check if range is set
      #
      # @return [Boolean]
      #
      # @api public
      def in?
        !!@in
      end

      # Check if response matches all the requirements set by the question
      #
      # @param [Object] value
      #
      # @return [Object]
      #
      # @api private
      def evaluate_response(value)
        return default_value if !value && default?

        check_required value
        return         if value.nil?
        check_valid    value unless valid_values.empty?
        within?        value
        validation.valid_value? value
        modifier.apply_to value
      end

      private

      # Check if value is present
      #
      # @api private
      def check_required(value)
        if required? && !default? && value.nil?
          raise ArgumentRequired, 'No value provided for required'
        end
      end

      # Check if value matches any of the expected values
      #
      # @api private
      def check_valid(value)
        if Array(value).all? { |val| valid_values.include? val }
          return value
        else raise InvalidArgument, "Valid values are: #{valid_values.join(', ')}"
        end
      end

      # Check if value is within expected range
      #
      # @api private
      def within?(value)
        if in? && value
          if @in.include?(value)
          else raise InvalidArgument, "Value #{value} is not included in the range #{@in}"
          end
        end
      end
    end # Question
  end # Shell
end # TTY
