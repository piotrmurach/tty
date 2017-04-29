# encoding: utf-8

require 'forwardable'
require 'pathname'
require 'tty-command'
require 'tty-which'
require 'tty-file'

module TTY
  class Cmd
    extend Forwardable

    GEMSPEC_PATH = Pathname(__dir__).join("../../tty.gemspec").realpath.to_s

    def_delegators :command, :run

    def_delegators :generator, :copy_file, :inject_into_file, :replace_in_file

    def execute(*)
      raise(
        NotImplementedError,
        "#{self.class}##{__method__} must be implemented"
      )
    end

    # The root path of the app running this command
    #
    # @return [Pathname]
    #
    # @api public
    def root_path
      @root_path ||= Pathname.pwd
    end

    # Execute command within root path
    #
    # @api public
    def within_root_path(&block)
      Dir.chdir(root_path, &block)
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
