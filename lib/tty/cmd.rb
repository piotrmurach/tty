# frozen_string_literal: true

require "forwardable"

require_relative "path_helpers"

module TTY
  class Cmd
    extend Forwardable
    include PathHelpers

    def_delegators :command, :run

    def_delegators "Thor::Util", :snake_case

    # Execute this command
    #
    # @api public
    def execute(*)
      raise(
        NotImplementedError,
        "#{self.class}##{__method__} must be implemented"
      )
    end

    COMMANDS_NAMESPACE = "Commands"

    # Infer relative command path
    #
    # @example
    #   CLI::Commands::Add # =>  "add"
    #
    # @example
    #   CLI::Commands::AddCommand # => "add"
    #
    # @example
    #   CLI::Commands::Generator::AddCommand # => "generator/add"
    #
    # @return [String]
    #
    # @api public
    def command_path
      @command_path ||= begin
        elements = self.class.name.to_s.split("::")
        index = elements.index(COMMANDS_NAMESPACE) || -1
        cmd_parts = elements[index+1..-1]
        if cmd_parts && !cmd_parts.empty?
          cmd_parts.map! { |cmd| snake_case(cmd) }
          path = ::File.join(*cmd_parts)
          path.chomp!("_command")
          path
        end
      end
    end

    # The external commands runner
    #
    # @see http://www.rubydoc.info/gems/tty-command
    #
    # @api public
    def command(**options)
      require "tty-command"
      TTY::Command.new(**options)
    end

    # The cursor movement
    #
    # @see http://www.rubydoc.info/gems/tty-cursor
    #
    # @api public
    def cursor
      require "tty-cursor"
      TTY::Cursor
    end

    # Open a file or text in the user's preferred editor
    #
    # @see http://www.rubydoc.info/gems/tty-editor
    #
    # @api public
    def editor
      require "tty-editor"
      TTY::Editor
    end

    # File manipulation utility methods
    #
    # @see http://www.rubydoc.info/gems/tty-file
    #
    # @api public
    def generator
      require "tty-file"
      TTY::File
    end

    # Terminal output paging
    #
    # @see http://www.rubydoc.info/gems/tty-pager
    #
    # @api public
    def pager(**options)
      require "tty-pager"
      TTY::Pager.new(options)
    end

    # Terminal platform and OS properties
    #
    # @see http://www.rubydoc.info/gems/tty-pager
    #
    # @api public
    def platform
      require "tty-platform"
      TTY::Platform.new
    end

    # The interactive prompt
    #
    # @see http://www.rubydoc.info/gems/tty-prompt
    #
    # @api public
    def prompt(**options)
      require "tty-prompt"
      TTY::Prompt.new(options)
    end

    # Get terminal screen properties
    #
    # @see http://www.rubydoc.info/gems/tty-screen
    #
    # @api public
    def screen
      require "tty-screen"
      TTY::Screen
    end

    # The unix which utility
    #
    # @see http://www.rubydoc.info/gems/tty-which
    #
    # @api public
    def which(*args)
      require "tty-which"
      TTY::Which.which(*args)
    end

    # Check if executable exists
    #
    # @see http://www.rubydoc.info/gems/tty-which
    #
    # @api public
    def exec_exist?(*args)
      require "tty-which"
      TTY::Which.exist?(*args)
    end

    def constantinize(str)
      str.gsub(/-[_-]*(?![_-]|$)/) { "::" }
         .gsub(/([_-]+|(::)|^)(.|$)/) { $2.to_s + $3.upcase}
    end
  end # Cmd
end # TTY
