# encoding: utf-8

module TTY
  class Terminal
    # A class responsible for toggling raw mode.
    class Raw
      # Turn raw mode on
      #
      # @api public
      def on
        %x{stty raw} if TTY::System.unix?
      end

      # Turn raw mode off
      #
      # @api public
      def off
        %x{stty -raw} if TTY::System.unix?
      end

      # Wrap code block inside raw mode
      #
      # @api public
      def raw(is_on=true, &block)
        value = nil
        begin
          on if is_on
          value = block.call if block_given?
          off
          return value
        rescue NoMethodError, Interrupt
          off
          exit
        end
      end
    end # Echo
  end # Terminal
end # TTY
