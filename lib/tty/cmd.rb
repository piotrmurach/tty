# encoding: utf-8

require 'forwardable'
require 'tty-command'

module TTY
  class Cmd
    extend Forwardable

    def_delegators :command, :run

    def execute(*)
      raise(
        NotImplementedError,
        "#{self.class}##{__method__} must be implemented"
      )
    end

    def command
      @command ||= TTY::Command.new(printer: :null)
    end
  end # Cmd
end # TTY
