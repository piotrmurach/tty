# encoding: utf-8

require 'forwardable'
require 'tty-command'
require 'tty-which'
require 'tty-file'

module TTY
  class Cmd
    extend Forwardable

    def_delegators :command, :run

    def_delegators :generator, :copy_file, :inject_into_file, :replace_in_file

    def execute(*)
      raise(
        NotImplementedError,
        "#{self.class}##{__method__} must be implemented"
      )
    end

    def generator
      @generator ||= TTY::File
    end

    def command
      @command ||= TTY::Command.new(printer: :null)
    end

    def which(*args)
      TTY::Which.which(*args)
    end

    def exec_exist?(*args)
      TTY::Which.exist?(*args)
    end
  end # Cmd
end # TTY
