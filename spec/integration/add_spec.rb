RSpec.describe 'teletype add', type: :cli do
  it "adds a command" do
    app_name = tmp_path('newcli')
    silent_run("teletype new #{app_name} --test rspec")

    output = <<-OUT
      create  spec/integration/server_spec.rb
      create  lib/newcli/commands/server.rb
      create  lib/newcli/templates/server/.gitkeep
      inject  lib/newcli/cli.rb
    OUT

    within_dir(app_name) do
      command = "teletype add server --no-color"

      out, err, status = Open3.capture3(command)

      expect(out).to match(output)
      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      # lib/newcli/commands/server.rb
      #
      expect(::File.read('lib/newcli/commands/server.rb')).to eq <<-EOS
# frozen_string_literal: true

require_relative '../command'

module Newcli
  module Commands
    class Server < Newcli::Command
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
# frozen_string_literal: true

require 'thor'

module Newcli
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
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

      # test setup
      #
      expect(::File.read('spec/integration/server_spec.rb')).to eq <<-EOS
RSpec.describe Newcli::Commands::Server do
  it "executes the command successfully" do
    output = `newcli server`
    expect(output).to eq("EXPECTED")
  end
end
      EOS
    end
  end

  it "adds a command with minitests" do
    app_name = tmp_path('newcli')
    silent_run("teletype new #{app_name} --test minitest")

    output = <<-OUT
      create  test/integration/server_test.rb
      create  lib/newcli/commands/server.rb
      create  lib/newcli/templates/server/.gitkeep
      inject  lib/newcli/cli.rb
    OUT

    within_dir(app_name) do
      command = "teletype add server --no-color"

      out, err, status = Open3.capture3(command)

      expect(out).to match(output)
      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      # test setup
      #
      expect(::File.read('test/integration/server_test.rb')).to eq <<-EOS
require "test_helper"

class Newcli::Commands::ServerTest < Minitest::Test
  def executes_the_command_successfully
    output = `newcli server`
    assert_equal "EXPECTED", output
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
      command = "teletype add server --no-color"

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
      command = "teletype add newServerCommand --no-color"

      _, err, status = Open3.capture3(command)

      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      expect(::File.read('lib/newcli/commands/new_server_command.rb')).to eq <<-EOS
# frozen_string_literal: true

require_relative '../command'

module Newcli
  module Commands
    class NewServerCommand < Newcli::Command
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
      command = "teletype add new_server_command --no-color"

      _, err, status = Open3.capture3(command)

      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      expect(::File.read('lib/newcli/commands/new_server_command.rb')).to eq <<-EOS
# frozen_string_literal: true

require_relative '../command'

module Newcli
  module Commands
    class NewServerCommand < Newcli::Command
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

  it "fails without command name" do
    output = <<-OUT.unindent
      ERROR: 'teletype add' was called with no arguments
      Usage: 'teletype add COMMAND_NAME'\n
    OUT
    command = "teletype add"
    out, err, status = Open3.capture3(command)
    expect([out, err, status.exitstatus]).to match_array([output, '', 1])
  end

  it "displays help" do
    output = <<-OUT
Usage:
  teletype add COMMAND [SUBCOMMAND] [OPTIONS]

Options:
  -a, [--args=arg1 arg2]           # List command argument names
  -d, [--desc=DESC]                # Describe command's purpose
  -f, [--force]                    # Overwrite existing command
  -h, [--help=HELP]                # Display usage information
      [--no-color]                 # Disable colorization in output
  -r, [--dry-run], [--no-dry-run]  # Run but do not make any changes
      [--debug], [--no-debug]      # Run in debug mode

Description:
  The `teletype add` will create a new command and place it into appropriate 
  structure in the cli app.

  Example: teletype add config --desc 'Set and get configuration options'

  This generates a command in app/commands/config.rb

  You can also add subcommands

  Example: teletype add config server

  This generates a command in app/commands/config/server.rb
    OUT

    command = "teletype add --help"
    out, err, status = Open3.capture3(command)
    expect(out).to eq(output)
    expect(err).to eq('')
    expect(status.exitstatus).to eq(0)
  end
end
