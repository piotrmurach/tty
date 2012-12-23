# -*- encoding: utf-8 -*-

module TTY
  class Shell

    # A class representing a question.
    class Question

      PREFIX          = " + "
      MULTIPLE_PREFIX = "   * "
      ERROR_PREFIX    = "  ERROR:"

      VALID_TYPES = [:boolean, :string, :symbol, :integer, :float, :date, :datetime]

      # Store question.
      #
      # @api private
      attr_accessor :question

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

      attr_reader :statement

      # Expected answer type
      #
      # @api private
      attr_reader :type

      # @api private
      attr_reader :shell
      private :shell

      def initialize(shell, statement, options={})
        @shell        = shell || Shell.new
        @statement    = statement
        @required     = options.fetch :required, false
        @modifier     = Modifier.new options.fetch(:modifier, [])
        @valid_values = options.fetch :valid, []
        @validation   = Validation.new options.fetch(:validation, nil)
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
        shell.say question
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

      # @api public
      def valid(value)
        @valid_values = value
        self
      end

      # @api private
      def check_valid(value)
        if Array(value).all? { |val| @valid_values.include? val }
          return value
        else raise InvalidArgument, "Valid values are: #{@valid_values.join(', ')}"
        end
      end

      # Reset question object.
      #
      # @api public
      def clean
        @question      = nil
        @type          = nil
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

      # @api public
      def on_error(action=nil)
        @error = action
        self
      end

      # @api private
      def read(type=nil)
        result = shell.input.gets
        if !result && default?
          return default_value
        end
        if required? && !default? && !result
          raise ArgumentRequired, 'No value provided for required'
        end
        validation.valid_value? result
        modifier.apply_to result
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

      # Ignore exception
      #
      # @api private
      def with_exception(&block)
        yield
      rescue
        block.call
      end

      # Reads string answer and validates against email regex
      #
      # @return [String]
      #
      # @api public
      def read_email
        validate(/^[a-z0-9._%+-]+@([a-z0-9-]+\.)+[a-z]{2,6}$/i)
        if error
          self.prompt statement
          with_exception { read_string }
        else
          read_string
        end
      end

      # Read answer provided on multiple lines
      #
      # @api public
      def read_multiple
        response = ""
        loop do
          value = read
          break if !value || value == ""
          response << value
        end
        response
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

    end # Question
  end # Shell
end # TTY
