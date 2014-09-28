# encoding: utf-8

require 'date'

module TTY
  # A class responsible for shell prompt interactions
  class Shell
    # A class representing a shell response
    class Response
      VALID_TYPES = [
        :boolean,
        :string,
        :symbol,
        :integer,
        :float,
        :date,
        :datetime
      ]

      attr_reader :reader
      private :reader

      attr_reader :shell
      private :shell

      attr_reader :question
      private :question

      # Initialize a Response
      #
      # @api public
      def initialize(question, shell = Shell.new)
        @bool_converter = Conversion::BooleanConverter.new
        @float_converter = Conversion::FloatConverter.new
        @range_converter = Conversion::RangeConverter.new
        @int_converter = Conversion::IntegerConverter.new

        @question = question
        @shell    = shell
        @reader   = Reader.new(shell)
      end

      # Read input from STDIN either character or line
      #
      # @param [Symbol] type
      #
      # @return [undefined]
      #
      # @api public
      def read(type = nil)
        question.evaluate_response read_input
      end

      # @api private
      def read_input
        reader = Reader.new(shell)

        if question.mask? && question.echo?
          reader.getc(question.mask)
        else
          TTY.terminal.echo(question.echo) do
            question.character? ? reader.getc(question.mask) : reader.gets
          end
        end
      end

      # Read answer and cast to String type
      #
      # @param [String] error
      #   error to display on failed conversion to string type
      #
      # @api public
      def read_string(error = nil)
        question.evaluate_response(String(read_input).strip)
      end

      # Read answer's first character
      #
      # @api public
      def read_char
        question.char(true)
        question.evaluate_response String(read_input).chars.to_a[0]
      end

      # Read multiple line answer and cast to String type
      #
      # @api public
      def read_text
        question.evaluate_response String(read_input)
      end

      # Read ansewr and cast to Symbol type
      #
      # @api public
      def read_symbol(error = nil)
        question.evaluate_response read_input.to_sym
      end

      # Read answer from predifined choicse
      #
      # @api public
      def read_choice(type = nil)
        question.argument(:required) unless question.default?
        question.evaluate_response read_input
      end

      # Read integer value
      #
      # @api public
      def read_int(error = nil)
        question.evaluate_response(@int_converter.convert(read_input))
      end

      # Read float value
      #
      # @api public
      def read_float(error = nil)
        question.evaluate_response(@float_converter.convert(read_input))
      end

      # Read regular expression
      #
      # @api public
      def read_regex(error = nil)
        question.evaluate_response Kernel.send(:Regex, read_input)
      end

      # Read range expression
      #
      # @api public
      def read_range
        question.evaluate_response(@range_converter.convert(read_input))
      end

      # Read date
      #
      # @api public
      def read_date
        question.evaluate_response Date.parse(read_input)
      end

      # Read datetime
      #
      # @api public
      def read_datetime
        question.evaluate_response DateTime.parse(read_input)
      end

      # Read boolean
      #
      # @api public
      def read_bool(error = nil)
        question.evaluate_response(@bool_converter.convert(read_input))
      end

      # Read file contents
      #
      # @api public
      def read_file(error = nil)
        question.evaluate_response File.open(File.join(directory, read_input))
      end

      # Read string answer and validate against email regex
      #
      # @return [String]
      #
      # @api public
      def read_email
        question.validate(/^[a-z0-9._%+-]+@([a-z0-9-]+\.)+[a-z]{2,6}$/i)
        question.prompt(question.statement) if question.error
        with_exception { read_string }
      end

      # Read answer provided on multiple lines
      #
      # @api public
      def read_multiple
        response = ''
        loop do
          value = question.evaluate_response read_input
          break if !value || value == ''
          next  if value !~ /\S/
          response << value
        end
        response
      end

      # Read password
      #
      # @api public
      def read_password
        question.echo false
        question.evaluate_response read_input
      end

      private

      # Ignore exception
      #
      # @api private
      def with_exception(&block)
        yield
      rescue
        question.error? ? block.call : raise
      end

      # @param [Symbol] type
      #   :boolean, :string, :numeric, :array
      #
      # @api private
      def read_type(class_or_name)
        raise TypeError, "Type #{type} is not valid" if type && !valid_type?(type)
        case type
        when :string, ::String
          read_string
        when :symbol, ::Symbol
          read_symbol
        when :float, ::Float
          read_float
        end
      end

      def valid_type?(type)
        self.class::VALID_TYPES.include? type.to_sym
      end
    end # Response
  end # Shell
end # TTY
