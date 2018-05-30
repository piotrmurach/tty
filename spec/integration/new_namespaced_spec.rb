RSpec.describe 'teletype new', type: :cli do
  it "generates cli application namespaced" do
    app_name = tmp_path('cli-app')

    output = <<-OUT
Creating gem 'cli-app'...
      create  tmp/cli-app/Gemfile
      create  tmp/cli-app/lib/cli/app.rb
      create  tmp/cli-app/lib/cli/app/version.rb
      create  tmp/cli-app/cli-app.gemspec
      create  tmp/cli-app/Rakefile
      create  tmp/cli-app/README.md
      create  tmp/cli-app/bin/console
      create  tmp/cli-app/bin/setup
      create  tmp/cli-app/.gitignore
      create  tmp/cli-app/.travis.yml
      create  tmp/cli-app/.rspec
      create  tmp/cli-app/spec/spec_helper.rb
      create  tmp/cli-app/spec/cli/app_spec.rb
      append  tmp/cli-app/README.md
      inject  tmp/cli-app/cli-app.gemspec
      create  tmp/cli-app/lib/cli/app/cli.rb
      create  tmp/cli-app/lib/cli/app/command.rb
      create  tmp/cli-app/exe/cli-app
      create  tmp/cli-app/LICENSE.txt
      create  tmp/cli-app/lib/cli/app/commands/.gitkeep
      create  tmp/cli-app/lib/cli/app/templates/.gitkeep
      create  tmp/cli-app/spec/integration/.gitkeep
      create  tmp/cli-app/spec/support/.gitkeep
      create  tmp/cli-app/spec/unit/.gitkeep
Initializing git repo in #{app_name}

Your teletype project has been created successfully.

Run "teletype help" for more commands.
    OUT

    command = "teletype new #{app_name} --no-coc --no-color --license mit"

    out, err, status = Open3.capture3(command)

    expect(out).to include(output)
    expect(err).to eq('')
    expect(status.exitstatus).to eq(0)

    within_dir(app_name) do

      # exe/cli-app
      #
      expect(::File.read('exe/cli-app')).to eq(<<-EOS)
#!/usr/bin/env ruby
# frozen_string_literal: true

lib_path = File.expand_path('../lib', __dir__)
$:.unshift(lib_path) if !$:.include?(lib_path)
require 'cli/app/cli'

Signal.trap('INT') do
  warn(\"\\n\#{caller.join(\"\\n\")}: interrupted\")
  exit(1)
end

begin
  Cli::App::CLI.start
rescue Cli::App::CLI::Error => err
  puts \"ERROR: \#{err.message}\"
  exit 1
end
      EOS

      # lib/cli/app/cli.rb
      #
      expect(::File.read('lib/cli/app/cli.rb')).to eq(<<-EOS)
# frozen_string_literal: true

require 'thor'

module Cli
  module App
    # Handle the application command line parsing
    # and the dispatch to various command objects
    #
    # @api public
    class CLI < Thor
      # Error raised by this runner
      Error = Class.new(StandardError)

      desc 'version', 'cli-app version'
      def version
        require_relative 'version'
        puts \"v\#{Cli::App::VERSION}\"
      end
      map %w(--version -v) => :version
    end
  end
end
    EOS

      # lib/newcli/cmd.rb
      #
      expect(::File.read('lib/cli/app/command.rb')).to eq(<<-EOS)
# frozen_string_literal: true

require 'forwardable'

module Cli
  module App
    class Command
      extend Forwardable

      def_delegators :command, :run

      # Execute this command
      #
      # @api public
      def execute(*)
        raise(
          NotImplementedError,
          "\#{self.class}#\#{__method__} must be implemented"
        )
      end

      # The external commands runner
      #
      # @see http://www.rubydoc.info/gems/tty-command
      #
      # @api public
      def command(**options)
        require 'tty-command'
        TTY::Command.new(options)
      end

      # The cursor movement
      #
      # @see http://www.rubydoc.info/gems/tty-cursor
      #
      # @api public
      def cursor
        require 'tty-cursor'
        TTY::Cursor
      end

      # Open a file or text in the user's preferred editor
      #
      # @see http://www.rubydoc.info/gems/tty-editor
      #
      # @api public
      def editor
        require 'tty-editor'
        TTY::Editor
      end

      # File manipulation utility methods
      #
      # @see http://www.rubydoc.info/gems/tty-file
      #
      # @api public
      def generator
        require 'tty-file'
        TTY::File
      end

      # Terminal output paging
      #
      # @see http://www.rubydoc.info/gems/tty-pager
      #
      # @api public
      def pager(**options)
        require 'tty-pager'
        TTY::Pager.new(options)
      end

      # Terminal platform and OS properties
      #
      # @see http://www.rubydoc.info/gems/tty-pager
      #
      # @api public
      def platform
        require 'tty-platform'
        TTY::Platform.new
      end

      # The interactive prompt
      #
      # @see http://www.rubydoc.info/gems/tty-prompt
      #
      # @api public
      def prompt(**options)
        require 'tty-prompt'
        TTY::Prompt.new(options)
      end

      # Get terminal screen properties
      #
      # @see http://www.rubydoc.info/gems/tty-screen
      #
      # @api public
      def screen
        require 'tty-screen'
        TTY::Screen
      end

      # The unix which utility
      #
      # @see http://www.rubydoc.info/gems/tty-which
      #
      # @api public
      def which(*args)
        require 'tty-which'
        TTY::Which.which(*args)
      end

      # Check if executable exists
      #
      # @see http://www.rubydoc.info/gems/tty-which
      #
      # @api public
      def exec_exist?(*args)
        require 'tty-which'
        TTY::Which.exist?(*args)
      end
    end
  end
end
    EOS
    end
  end
end
