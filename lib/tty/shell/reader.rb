# encoding: utf-8

module TTY
  # A class responsible for shell prompt interactions.
  class Shell
    # A class responsible for reading character input from STDIN
    class Reader
      # @api private
      attr_reader :shell
      private :shell

      # Key input constants for decimal codes
      CARRIAGE_RETURN = 13.freeze
      NEWLINE         = 10.freeze
      BACKSPACE       = 127.freeze
      DELETE          = 8.freeze

      # Initialize a Reader
      #
      # @api public
      def initialize(shell = Shell.new)
        @shell = shell
      end

      # Get input in unbuffered mode.
      #
      # @example
      #   buffer do
      #     ...
      #   end
      #
      # @return [String]
      #
      # @api public
      def buffer(&block)
        bufferring = shell.output.sync
        # Immediately flush output
        shell.output.sync = true

        value = block.call if block_given?

        shell.output.sync = bufferring
        value
      end

      # Get a value from STDIN one key at a time. Each key press is echoed back
      # to the shell masked with character(if given). The input finishes when
      # enter key is pressed.
      #
      # @param [String] mask
      #   the character to use as mask
      #
      # @return [String]
      #
      # @api public
      def getc(mask = (not_set = true))
        value = ''
        buffer do
          begin
            while (char = shell.input.getbyte) &&
                !(char == CARRIAGE_RETURN || char == NEWLINE)
              value = handle_char value, char, not_set, mask
            end
          ensure
            TTY.terminal.echo_on
          end
        end
        value
      end

      # Get a value from STDIN using line input.
      #
      # @api public
      def gets
        shell.input.gets
      end

      # Reads at maximum +maxlen+ characters.
      #
      # @param [Integer] maxlen
      #
      # @api public
      def readpartial(maxlen)
        shell.input.readpartial(maxlen)
      end

      private

      # Handle single character by appending to or removing from output
      #
      # @api private
      def handle_char(value, char, not_set, mask)
        if char == BACKSPACE || char == DELETE
          value.slice!(-1, 1) unless value.empty?
        else
          print_char char, not_set, mask
          value << char
        end
        value
      end

      # Print out character back to shell STDOUT
      #
      # @api private
      def print_char(char, not_set, mask)
        shell.output.putc((not_set || !mask) ? char : mask)
      end
    end # Reader
  end # Shell
end # TTY
