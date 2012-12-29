# -*- encoding: utf-8 -*-

module TTY
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
      def initialize(shell=nil)
        @shell = shell || Shell.new
      end

      # Get input in unbuffered mode.
      #
      #
      # @api bublic
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
      def getc(mask=(not_set=true))
        value = ""

        buffer do
          begin
            while (char = shell.input.getbyte) and
                !(char == CARRIAGE_RETURN || char == NEWLINE)

              if (char == BACKSPACE || char == DELETE)
                value.slice!(-1, 1) unless value.empty?
              else
                # shell.stdout.putc mask
                if not_set || !mask
                  shell.output.putc char
                else
                  shell.output.putc mask.chr
                end
                value << char
              end
            end
          ensure
            TTY.terminal.echo_on
          end
        end

        value
      end

    end # Reader
  end # Shell
end # TTY
