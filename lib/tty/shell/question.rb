# -*- encoding: utf-8 -*-

module TTY
  class Shell

    # A class representing a question.
    class Question < Shell

      PREFIX          = " + "
      MULTIPLE_PREFIX = "   * "
      ERROR_PREFIX    = "  ERROR:"

      VALID_TYPES = [:boolean, :string, :symbol, :integer, :float, :date, :datetime]

      MODIFIERS = [
        :none,
        :lowercase, # convert to lower case
        :uppercase, # convert to upper case
        :trim       # trim spaces
      ].freeze

      # Store question.
      #
      # @api private
      attr_accessor :question

      # Store default value.
      #
      # @api private
      attr_reader :default_value

      attr_reader :required

      attr_reader :validation

      attr_reader :modifier

      attr_reader :valid_values

      # Expected answer type
      #
      # @api private
      attr_reader :type

      # Available modifications for the answer token.
      attr_reader :modifiers

      def initialize(input, output)
        super
        @required = false
        @modifier = :none
        @valid_values = []
      end

      # Check if required argument present.
      #
      # @api private
      def required?
        required
      end

      # Set a new prompt
      #
      # @param [String] message
      #
      # @return [self]
      #
      def prompt(message)
        self.question = message
        say question
        self
      end

      # Set default value.
      #
      # @api public
      def default(value)
        @default_value = value
        self
      end

      def default?
        !!@default_value
      end

      # @api public
      def argument(value)
        case value
        when :required
          @required = true
        end
        self
      end

      # Set validation rule for an argument
      #
      # @param [Object] value
      #
      # @api public
      def validate(value=nil, &block)
        @validation = coerce_validation(value || block)
        self
      end

      def valid(value)
        @valid_values = value
        self
      end

      def check_valid(value)
        if Array(value).all? { |val| @valid_values.include? val }
          return value
        else raise InvalidArgument, "Valid values are: #{@valid_values.join(', ')}"
        end
      end

      # @api public
      def validate?
        !!validation
      end

      # Reset question object.
      def clean
        @question      = nil
        @type          = nil
        @default_value = nil
        @required      = false
        @modifier      = :none
      end

      # @api private
      def read(type=nil)
        result = input.gets
        if required? and result.nil?
          raise ArgumentRequired, 'No value provided for required' 
        end
        if result == nil and default_value !=nil
          return default_value
        end
        check_validation result
        apply_modifier result
      end

      def apply_modifier(value)
        case modifier
        when :uppercase
          value.upcase
        when :lowercase
          value.downcase
        when :trim
          value
        else
          value
        end
      end

      # Check if provided value passes validation
      #
      # @param [String] value
      #
      # @api private
      def check_validation(value)
        if validate?
          if validation.is_a?(Regexp) && validation =~ value
          elsif validation.is_a?(Proc) && validation.call(value)
          else raise ArgumentError, "Invalid input for #{value}"
          end
        end
      end

      # Read answer and cast to String type
      #
      # @param [String] error
      #   error to display on failed conversion to string type
      #
      # @api public
      def read_string(error=nil)
        String(read)
      end

      # Read multiple line answer and cast to String type
      def read_text
        String(read)
      end

      # Read ansewr and cast to Symbol type
      def read_symbol(error=nil)
        read.to_sym
      end

      def read_int(error=nil)
        Kernel.send(:Integer, read)
      end

      def read_float(error=nil)
        Kernel.send(:Float, read)
      end

      def read_regex(error=nil)
        Kernel.send(:Regex, read)
      end

      def read_date
        Date.parse(read)
      end

      def read_datetime
        DateTime.parse(read)
      end

      def read_bool(error=nil)
        parse_boolean read
      end

      def read_choice(type=nil)
        @required = true unless default?
        check_valid read
      end

      def read_file(error=nil)
        File.open(File.join(directory, read))
      end

      # Modify string according to the rule given.
      #
      # @param [Symbol] rule
      #
      # @api public
      def modify(rule)
        @modifier = rule.to_sym
        self
      end

      protected

      # @param [Symbol] type
      #   :boolean, :string, :numeric, :array
      #
      # @api private
      def read_type(type)
        raise TypeError, "Type #{type} is not valid" if type && !valid_type?(type)
        case type
        when :string
          read_string
        when :symbol
          read_symbol
        when :float
          read_float
        end
      end

      def valid_type?(type)
        self.class::VALID_TYPES.include? type.to_sym
      end

      # Convert message into boolean type
      #
      # @param [String] message
      #
      # @return [Boolean]
      #
      # @api private
      def parse_boolean(message)
        case message.to_s
        when %r/^(yes|y)$/i
          return true
        when %r/^(no|n)$/i
          return false
        else
          raise TypeError, "Expected boolean type, got #{message}"
        end
      end

      # Convert validation into known type.
      #
      # @param [Object] validation
      #
      # @api private
      def coerce_validation(validation)
        case validation
        when Proc
          validation
        when Regexp, String
          Regexp.new(validation.to_s)
        else
          raise ValidationCoercion, "Wrong type, got #{validation.class}"
        end
      end

    end # Question
  end # Shell
end # TTY
