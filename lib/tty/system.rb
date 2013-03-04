# -*- encoding: utf-8 -*-

require 'rbconfig'

module TTY
  class System

    class << self

      # Check if windows platform.
      #
      # @return [Boolean]
      #
      # @api public
      def windows?
        RbConfig::CONFIG['host_os'] =~ /msdos|mswin|djgpp|mingw|windows/
      end

      # Check if unix platform
      #
      # @return [Boolean]
      #
      # @api public
      def unix?
        RbConfig::CONFIG['host_os'] =~ /(aix|darwin|linux|(net|free|open)bsd|cygwin|solaris|irix|hpux)/i
      end

      # Find an executable in the PATH
      #
      # @see TTY::System::Which
      #
      # @api public
      def which(command)
        Which.new(command)
      end
    end

  end # System
end # TTY
