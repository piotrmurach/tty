# -*- encoding: utf-8 -*-

module TTY
  class Shell

    # A class representing a question.
    class Question < Shell

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

      # Expected answer type
      #
      # @api private
      attr_reader :type

      # Available modifications for the answer token.
      attr_reader :modifiers

      def initialize(input, output)
        super
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

      # @api public
      def option(value)
        case value
        when :required
          @required = true
        end
        self
      end

      # Reset question object.
      def clean
        @question      = nil
        @type          = nil
        @default_value = nil
      end

      # @api private
      def read(type=nil)
        result = input.gets
        if required? and result.nil?
          raise ArgumentError, 'No value provided for required' 
        end
        if result == nil and default_value !=nil
          return default_value
        end
        result
      end

      #
      # @param [String] error
      #   error to display on failed conversion to string type
      #
      # @api public
      def read_string(error=nil)
        String(read)
      end

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

      def read_choice(type, options)
        read
      end

      def read_file(error=nil)
        File.open(File.join(directory, read))
      end

      # Modify string according to the rule given.
      #
      # @api public
      def modify(string, rule)
      end

      protected

      # @param [Symbol] type
      #   :boolean, :string, :numeric, :array
      #
      # @api private
      def read_type(type)
        raise ArgumentError, "Type #{type} is not valid" if type && !valid_type?(type)
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
        self.class::VALID_TYPES.include(type.to_sym)
      end

      def parse_boolean(message)
        case message.to_s
        when %r/^(yes|y)$/i
          return true
        when %r/^(no|n)$/i
          return false
        else
          raise ArgumentError, "Expected boolean type, got #{message}"
        end
      end

    end # Question
  end # Shell
end # TTY
