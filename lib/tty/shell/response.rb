# -*- encoding: utf-8 -*-

require 'date'

module TTY
  # A class responsible for shell prompt interactions.
  class Shell

    # A class representing a question.
    class Response

      VALID_TYPES = [:boolean, :string, :symbol, :integer, :float, :date, :datetime]
      attr_reader :reader
      private :reader

      attr_reader :shell
      private :shell

      attr_reader :question
      private :question

      # Initialize a Response
      #
      # @api public
      def initialize(question, shell=nil)
        @question = question
        @shell    = shell || Shell.new
        @reader   = Reader.new(shell)
      end

      # Read input from STDIN either character or line
      #
      # @param [Symbol] type
      #
      # @return [undefined]
      #
      # @api public
      def read(type=nil)
        question.evaluate_response read_input
      end

      # @api private
      def read_input
        reader = Reader.new(shell)

        if question.mask? && question.echo?
          reader.getc(question.mask)
        else
          TTY.terminal.echo(question.echo) {
            question.character? ? reader.getc(question.mask) : reader.gets
          }
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

      # Read answer's first character
      #
      # @api public
      def read_char
        question.character true
        String(read).chars.to_a[0]
      end

      # Read multiple line answer and cast to String type
      #
      # @api public
      def read_text
        String(read)
      end

      # Read ansewr and cast to Symbol type
      #
      # @api public
      def read_symbol(error=nil)
        read.to_sym
      end

      # Read answer from predifined choicse
      #
      # @api public
      def read_choice(type=nil)
        question.argument(:required) unless question.default?
        read
      end

      # Read integer value
      #
      # @api public
      def read_int(error=nil)
        Kernel.send(:Integer, read)
      end

      # Read float value
      #
      # @api public
      def read_float(error=nil)
        Kernel.send(:Float, read)
      end

      # Read regular expression
      #
      # @api public
      def read_regex(error=nil)
        Kernel.send(:Regex, read)
      end

      # Read date
      #
      # @api public
      def read_date
        Date.parse(read)
      end

      # Read datetime
      #
      # @api public
      def read_datetime
        DateTime.parse(read)
      end

      # Read boolean
      #
      # @api public
      def read_bool(error=nil)
        Boolean.coerce read
      end

      # Read file contents
      #
      # @api public
      def read_file(error=nil)
        File.open(File.join(directory, read))
      end

      # Read string answer and validate against email regex
      #
      # @return [String]
      #
      # @api public
      def read_email
        question.validate(/^[a-z0-9._%+-]+@([a-z0-9-]+\.)+[a-z]{2,6}$/i)
        if question.error
          question.prompt question.statement
        end
        with_exception { read_string }
      end

      # Read answer provided on multiple lines
      #
      # @api public
      def read_multiple
        response = ""
        loop do
          value = read
          break if !value || value == ""
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
        read
      end

      private

      # Ignore exception
      #
      # @api private
      def with_exception(&block)
        yield
      rescue
        question.error ? block.call : raise
      end

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

    end # Response
  end # Shell
end # TTY
