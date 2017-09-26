# encoding: utf-8
# frozen_string_literal: true

require 'forwardable'
require 'tty-command'
require 'tty-editor'
require 'tty-file'
require 'tty-pager'
require 'tty-platform'
require 'tty-prompt'
require 'tty-screen'
require 'tty-which'

require_relative 'path_helpers'

module TTY
  class Cmd
    extend Forwardable
    include PathHelpers

    def_delegators :command, :run

    def_delegators 'Thor::Util', :snake_case

    # Execute this command
    #
    # @api public
    def execute(*)
      raise(
        NotImplementedError,
        "#{self.class}##{__method__} must be implemented"
      )
    end

    # The external commands runner
    #
    # @see http://www.rubydoc.info/gems/tty-command
    #
    # @api public
    def command(**options)
      @command ||= TTY::Command.new(options)
    end

    # Open a file or text in the user's preferred editor
    #
    # @see http://www.rubydoc.info/gems/tty-editor
    #
    # @api public
    def editor
      TTY::Editor
    end

    # File manipulation utility methods
    #
    # @see http://www.rubydoc.info/gems/tty-file
    #
    # @api public
    def generator
      TTY::File
    end

    # Terminal output paging
    #
    # @see http://www.rubydoc.info/gems/tty-pager
    #
    # @api public
    def pager(**options)
      @pager ||= TTY::Pager.new(options)
    end

    # Terminal platform and OS properties
    #
    # @see http://www.rubydoc.info/gems/tty-pager
    #
    # @api public
    def platform
      @platform ||= TTY::Platform.new
    end

    # The interactive prompt
    #
    # @see http://www.rubydoc.info/gems/tty-prompt
    #
    # @api public
    def prompt(**options)
      @prompt ||= TTY::Prompt.new(options)
    end

    # Get terminal screen properties
    #
    # @see http://www.rubydoc.info/gems/tty-screen
    #
    # @api public
    def screen
      TTY::Screen
    end

    # The unix which utility
    #
    # @see http://www.rubydoc.info/gems/tty-which
    #
    # @api public
    def which(*args)
      TTY::Which.which(*args)
    end

    # Check if executable exists
    #
    # @see http://www.rubydoc.info/gems/tty-which
    #
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
