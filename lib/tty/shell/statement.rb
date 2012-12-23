# -*- encoding: utf-8 -*-

module TTY
  class Shell

    # A class representing a statement output to shell.
    class Statement

      # @api private
      attr_reader :shell
      private :shell

      attr_reader :newline

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
      def initialize(shell=nil, options={})
        @shell = shell || Shell.new
        @newline = options.fetch :newline, true
        @color   = options.fetch :color, nil
      end

      # Output the message to the shell
      #
      # @param [String] message
      #   the message to be printed to stdout
      #
      # @api public
      def declare(message)
        message = TTY::terminal.color.set message, *color if color

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
