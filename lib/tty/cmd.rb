# encoding: utf-8

require 'forwardable'
require 'pathname'
require 'tty-command'
require 'tty-prompt'
require 'tty-which'
require 'tty-file'

require_relative 'path_helpers'

module TTY
  class Cmd
    extend Forwardable
    include PathHelpers

    GEMSPEC_PATH = Pathname(__dir__).join('../../tty.gemspec').realpath.to_s

    def_delegators :command, :run

    def_delegators :generator, :copy_file, :inject_into_file, :replace_in_file

    def_delegators 'Thor::Util', :snake_case

    # @api public
    def execute(*)
      raise(
        NotImplementedError,
        "#{self.class}##{__method__} must be implemented"
      )
    end

    # @api public
    def generator
      @generator ||= TTY::File
    end

    # @api public
    def command
      @command ||= TTY::Command.new(printer: :null)
    end

    # @api public
    def prompt
      @prompt ||= TTY::Prompt.new
    end

    # @api public
    def which(*args)
      TTY::Which.which(*args)
    end

    # @api public
    def exec_exist?(*args)
      TTY::Which.exist?(*args)
    end

    def constantinize(str)
      str.gsub(/\/(.?)/) { "::#{$1.upcase}" }
         .gsub(/(?:\A|_)(.)/) { $1.upcase }
    end
  end # Cmd
end # TTY
