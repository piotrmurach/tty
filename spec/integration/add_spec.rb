# encoding: utf-8

RSpec.describe 'teletype add', type: :cli do
  it "adds a command" do
    app_name = tmp_path('newcli')
    silent_run("bundle exec teletype new #{app_name}")

    # create newcli/spec/integration/server_spec.rb
    output = <<-OUT
      create  lib/newcli/commands/server.rb
      inject  lib/newcli/cli.rb
    OUT

    within_dir(app_name) do
      command = "bundle exec teletype add server --no-color"

      out, err, status = Open3.capture3(command)

      expect(out).to match(output)
      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      # lib/newcli/commands/server.rb
      #
      expect(::File.read('lib/newcli/commands/server.rb')).to eq <<-EOS
# encoding: utf-8
# frozen_string_literal: true

require_relative '../cmd'

module Newcli
  module Commands
    class Server < Newcli::Cmd
      def initialize(options)
        @options = options
      end

      def execute
        # Command logic goes here ...
      end
    end
  end
end
      EOS

      expect(::File.read('lib/newcli/cli.rb')).to eq <<-EOS
# encoding: utf-8
# frozen_string_literal: true

require 'thor'

module Newcli
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'newcli version'
    def version
      require_relative 'version'
      puts \"v\#{Newcli::VERSION}\"
    end
    map %w(--version -v) => :version

    desc 'server', 'Command description...'
    def server(*)
      if options[:help]
        invoke :help, ['server']
      else
        require_relative 'commands/server'
        Newcli::Commands::Server.new(options).execute
      end
    end
  end
end
      EOS
    end
  end

  it "adds command in cli without any commands" do
    app_path = tmp_path('newcli')
    cli_template = <<-EOS
require 'thor'

module Newcli
  class CLI < Thor
  end
end
    EOS
    dir = {
      app_path => [
        'lib' => [
          'newcli' => [
            ['cli.rb', cli_template]
          ]
        ]
      ]
    }

    ::TTY::File.create_dir(dir, verbose: false)
    within_dir(app_path) do
      command = "bundle exec teletype add server --no-color"

      _, err, status = Open3.capture3(command)

      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      expect(::File.read('lib/newcli/cli.rb')).to eq <<-EOS
require 'thor'

module Newcli
  class CLI < Thor

    desc 'server', 'Command description...'
    def server(*)
      if options[:help]
        invoke :help, ['server']
      else
        require_relative 'commands/server'
        Newcli::Commands::Server.new(options).execute
      end
    end
  end
end
      EOS
    end
  end

  it "adds complex command name as camel case" do
    app_path = tmp_path('newcli')
    cli_template = <<-EOS
require 'thor'

module Newcli
  class CLI < Thor
  end
end
    EOS
    dir = {
      app_path => [
        'lib' => [
          'newcli' => [
            ['cli.rb', cli_template]
          ]
        ]
      ]
    }
    ::TTY::File.create_dir(dir, verbose: false)
    within_dir(app_path) do
      command = "bundle exec teletype add newServerCommand --no-color"

      _, err, status = Open3.capture3(command)

      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      expect(::File.read('lib/newcli/commands/new_server_command.rb')).to eq <<-EOS
# encoding: utf-8
# frozen_string_literal: true

require_relative '../cmd'

module Newcli
  module Commands
    class NewServerCommand < Newcli::Cmd
      def initialize(options)
        @options = options
      end

      def execute
        # Command logic goes here ...
      end
    end
  end
end
      EOS

      expect(::File.read('lib/newcli/cli.rb')).to eq <<-EOS
require 'thor'

module Newcli
  class CLI < Thor

    desc 'new_server_command', 'Command description...'
    def new_server_command(*)
      if options[:help]
        invoke :help, ['new_server_command']
      else
        require_relative 'commands/new_server_command'
        Newcli::Commands::NewServerCommand.new(options).execute
      end
    end
  end
end
      EOS
    end
  end

  it "adds complex command name as snake case" do
    app_path = tmp_path('newcli')
    cli_template = <<-EOS
require 'thor'

module Newcli
  class CLI < Thor
  end
end
    EOS
    dir = {
      app_path => [
        'lib' => [
          'newcli' => [
            ['cli.rb', cli_template]
          ]
        ]
      ]
    }
    ::TTY::File.create_dir(dir, verbose: false)

    within_dir(app_path) do
      command = "bundle exec teletype add new_server_command --no-color"

      _, err, status = Open3.capture3(command)

      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      expect(::File.read('lib/newcli/commands/new_server_command.rb')).to eq <<-EOS
# encoding: utf-8
# frozen_string_literal: true

require_relative '../cmd'

module Newcli
  module Commands
    class NewServerCommand < Newcli::Cmd
      def initialize(options)
        @options = options
      end

      def execute
        # Command logic goes here ...
      end
    end
  end
end
      EOS

      expect(::File.read('lib/newcli/cli.rb')).to eq <<-EOS
require 'thor'

module Newcli
  class CLI < Thor

    desc 'new_server_command', 'Command description...'
    def new_server_command(*)
      if options[:help]
        invoke :help, ['new_server_command']
      else
        require_relative 'commands/new_server_command'
        Newcli::Commands::NewServerCommand.new(options).execute
      end
    end
  end
end
      EOS
    end
  end

  it "prevents adding already existing command"

  it "fails without command name" do
    output = <<-OUT.unindent
      ERROR: 'teletype add' was called with no arguments
      Usage: 'teletype add COMMAND_NAME'\n
    OUT
    command = "bundle exec teletype add"
    out, err, status = Open3.capture3(command)
    expect([out, err, status.exitstatus]).to match_array([output, '', 1])
  end

  it "displays help" do
    output = <<-OUT
Usage:
  teletype add COMMAND_NAME [OPTIONS]

Options:
  -h, [--help=HELP]                # Display usage information.
      [--no-color]                 # Disable colorization in output.
  -r, [--dry-run], [--no-dry-run]  # Run but do not make any changes.
      [--debug], [--no-debug]      # Run with debug logging.

Description:
  The `teletype add` will create a new command and place it into appropriate 
  structure in the cli app.

  Example: teletype add config

  This generates a command in app/commands/config.rb
    OUT

    command = "bundle exec teletype add --help"
    out, err, status = Open3.capture3(command)
    expect(out).to eq(output)
    expect(err).to eq('')
    expect(status.exitstatus).to eq(0)
  end
end
