# -*- encoding: utf-8 -*-

require 'date'

module TTY
  # A class responsible for shell prompt interactions.
  class Shell

    # A class representing a question.
    class Question
      extend TTY::Delegatable

      PREFIX          = " + "
      MULTIPLE_PREFIX = "   * "
      ERROR_PREFIX    = "  ERROR:"

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

      # Controls character processing to the answer
      #
      # @api public
      attr_reader :modifier

      attr_reader :valid_values

      attr_reader :error

      attr_reader :echo

      attr_reader :mask

      attr_reader :character

      # @api private
      attr_reader :shell
      private :shell

      attr_reader :response

      delegatable_method :response, :read

      delegatable_method :response, :read_string

      delegatable_method :response, :read_char

      delegatable_method :response, :read_text

      delegatable_method :response, :read_symbol

      delegatable_method :response, :read_choice

      delegatable_method :response, :read_int

      delegatable_method :response, :read_float

      delegatable_method :response, :read_regex

      delegatable_method :response, :read_date

      delegatable_method :response, :read_datetime

      delegatable_method :response, :read_bool

      delegatable_method :response, :read_file

      delegatable_method :response, :read_email

      delegatable_method :response, :read_multiple

      delegatable_method :response, :read_password

      # Initialize a Question
      #
      # @api public
      def initialize(shell, options={})
        @shell        = shell || Shell.new
        @required     = options.fetch(:required) { false }
        @echo         = options.fetch(:echo) { true }
        @mask         = options.fetch(:mask) { false  }
        @character    = options.fetch(:character) { false }
        @in           = options.fetch(:in) { false }
        @modifier     = Modifier.new options.fetch(:modifier) { [] }
        @valid_values = options.fetch(:valid) { [] }
        @validation   = Validation.new options.fetch(:validation) { nil }

        @response = Response.new(self, shell)
      end

      # Set a new prompt
      #
      # @param [String] message
      #
      # @return [self]
      #
      def prompt(message)
        self.statement = message
        shell.say statement
        self
      end

      # Set default value.
      #
      # @api public
      def default(value)
        return self if value == ""
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
      def validate(value=nil, &block)
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
        @modifier = Modifier.new *rules
        self
      end

      # Setup behaviour when error(s) occur
      #
      # @api public
      def on_error(action=nil)
        @error = action
        self
      end

      # Turn terminal echo on or off. This is used to secure the display so
      # that the entered characters are not echoed back to the screen.
      #
      # @api public
      def echo(value=(not_set=true))
        return @echo if not_set
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
      def mask(character=(not_set=true))
        return @mask if not_set
        @mask = character
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
      def character(value=(not_set=true))
        return @character if not_set
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

      def in(value=(not_set=true))
        return @in if not_set
        @in = TTY::Coercer::Range.coerce value
        self
      end

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
        if !value && default?
          return default_value
        end
        if required? && !default? && !value
          raise ArgumentRequired, 'No value provided for required'
        end
        check_valid value unless valid_values.empty?
        within? value
        validation.valid_value? value
        modifier.apply_to value
      end

      # @api private
      def check_valid(value)
        if Array(value).all? { |val| valid_values.include? val }
          return value
        else raise InvalidArgument, "Valid values are: #{valid_values.join(', ')}"
        end
      end

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
