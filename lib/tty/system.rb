# encoding: utf-8

require 'rbconfig'

module TTY
  class System
    # Find an executable in the PATH
    #
    # @see TTY::System::Which
    #
    # @api public
    def self.which(command)
      Which.new(command).which
    end

    # Check if command is available
    #
    # @param [String] name
    #   the command name
    #
    # @api public
    def self.exists?(name)
      !!which(name)
    end

    # Proxy to editor object
    #
    # @return [TTY::System::Editor]
    #
    # @api public
    def self.editor
      TTY::System::Editor
    end
  end # System
end # TTY
