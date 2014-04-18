# encoding: utf-8

module TTY
  # A class responsible for shell prompt interactions.
  class Shell
    # A class representing a statement output to shell.
    class Statement
      # @api private
      attr_reader :shell
      private :shell

      # Flag to display newline
      #
      # @api public
      attr_reader :newline

      # Color used to display statement
      #
      # @api public
      attr_reader :color

      # Initialize a Statement
      #
      # @param [TTY::Shell] shell
      #
      # @param [Hash] options
      #
      # @option options [Symbol] :newline
      #   force a newline break after the message
      #
      # @option options [Symbol] :color
      #   change the message display to color
      #
      # @api public
      def initialize(shell = Shell.new, options = {})
        @shell   = shell
        @newline = options.fetch(:newline, true)
        @color   = options.fetch(:color, nil)
      end

      # Output the message to the shell
      #
      # @param [String] message
      #   the message to be printed to stdout
      #
      # @api public
      def declare(message)
        message = TTY.terminal.color.set message, *color if color

        if newline && /( |\t)(\e\[\d+(;\d+)*m)?\Z/ !~ message
          shell.output.puts message
        else
          shell.output.print message
          shell.output.flush
        end
      end
    end # Statement
  end # Shell
end # TTY
