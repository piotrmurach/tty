RSpec.describe "teletype add", type: :cli do
  it "adds a comand to namespaced application" do
    app_name = tmp_path('cli-app')
    silent_run("teletype new #{app_name} --test rspec")

    output = <<-OUT
      create  spec/integration/server_spec.rb
      create  spec/unit/server_spec.rb
      create  lib/cli/app/commands/server.rb
      create  lib/cli/app/templates/server/.gitkeep
      inject  lib/cli/app/cli.rb
    OUT

    within_dir(app_name) do
      command = "teletype add server --no-color"

      out, err, status = Open3.capture3(command)

      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)
      expect(out).to eq(output)

      # lib/cli/app/commands/server.rb
      #
      expect(::File.read('lib/cli/app/commands/server.rb')).to eq <<-EOS
# frozen_string_literal: true

require_relative '../command'

module Cli
  module App
    module Commands
      class Server < Cli::App::Command
        def initialize(options)
          @options = options
        end

        def execute(input: $stdin, output: $stdout)
          # Command logic goes here ...
          output.puts "OK"
        end
      end
    end
  end
end
      EOS

      # lib/cli/app/cli.rb
      #
      expect(::File.read('lib/cli/app/cli.rb')).to eq <<-EOS
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

      desc 'server', 'Command description...'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
      def server(*)
        if options[:help]
          invoke :help, ['server']
        else
          require_relative 'commands/server'
          Cli::App::Commands::Server.new(options).execute
        end
      end
    end
  end
end
      EOS

      # test setup
      #
      expect(::File.read('spec/integration/server_spec.rb')).to eq <<-EOS
RSpec.describe "`cli-app server` command", type: :cli do
  it "executes `cli-app help server` command successfully" do
    output = `cli-app help server`
    expect(output).to eq <<-OUT
Usage:
  cli-app server

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT
  end
end
      EOS

      expect(::File.read('spec/unit/server_spec.rb')).to eq <<-EOS
require 'cli/app/commands/server'

RSpec.describe Cli::App::Commands::Server do
  it "executes `server` command successfully" do
    output = StringIO.new
    options = {}
    command = Cli::App::Commands::Server.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\\n")
  end
end
      EOS
    end
  end
end
