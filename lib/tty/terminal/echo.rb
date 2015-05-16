# encoding: utf-8

module TTY
  class Terminal
    # A class responsible for toggling echo.
    class Echo
      # Turn echo on
      #
      # @api public
      def on
        %x{stty echo} if TTY::Platform.unix?
      end

      # Turn echo off
      #
      # @api public
      def off
        %x{stty -echo} if TTY::Platform.unix?
      end

      # Wrap code block inside echo
      #
      # @api public
      def echo(is_on=true, &block)
        value = nil
        begin
          off unless is_on
          value = block.call if block_given?
          on
          return value
        rescue NoMethodError, Interrupt
          on
          exit
        end
      end
    end # Echo
  end # Terminal
end # TTY
