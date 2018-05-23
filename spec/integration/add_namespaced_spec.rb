RSpec.describe "teletype add", type: :cli do
  it "adds a command to namespaced application" do
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
      expect(out).to eq(output)
      expect(status.exitstatus).to eq(0)

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
    expected_output = <<-OUT
Usage:
  cli-app server

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
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

  it "adds a subcommand to namespaced application" do
    app_name = tmp_path('cli-app')
    silent_run("teletype new #{app_name} --test rspec")

    output = <<-OUT
      create  spec/integration/config_spec.rb
      create  spec/integration/config/set_spec.rb
      create  spec/unit/config/set_spec.rb
      create  lib/cli/app/commands/config.rb
      create  lib/cli/app/commands/config/set.rb
      create  lib/cli/app/templates/config/set/.gitkeep
      inject  lib/cli/app/cli.rb
      inject  lib/cli/app/commands/config.rb
    OUT

    within_dir(app_name) do
      command_set = "teletype add config set --no-color"

      out, err, status = Open3.capture3(command_set)

      expect(err).to eq('')
      expect(out).to eq(output)
      expect(status.exitstatus).to eq(0)

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

      require_relative 'commands/config'
      register Cli::App::Commands::Config, 'config', 'config [SUBCOMMAND]', 'Command description...'
    end
  end
end
      EOS

      # lib/cli/app/commands/config.rb
      #
      expect(::File.read('lib/cli/app/commands/config.rb')).to eq <<-EOS
# frozen_string_literal: true

require 'thor'

module Cli
  module App
    module Commands
      class Config < Thor

        namespace :config

        desc 'set', 'Command description...'
        method_option :help, aliases: '-h', type: :boolean,
                             desc: 'Display usage information'
        def set(*)
          if options[:help]
            invoke :help, ['set']
          else
            require_relative 'config/set'
            Cli::App::Commands::Config::Set.new(options).execute
          end
        end
      end
    end
  end
end
      EOS

      # Subcommand `set`
      #
      expect(::File.read('lib/cli/app/commands/config/set.rb')).to eq <<-EOS
# frozen_string_literal: true

require_relative '../../command'

module Cli
  module App
    module Commands
      class Config
        class Set < Cli::App::Command
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
end
      EOS

      # test setup
      #
      expect(::File.read('spec/integration/config_spec.rb')).to eq <<-EOS
RSpec.describe "`cli-app config` command", type: :cli do
  it "executes `cli-app help config` command successfully" do
    output = `cli-app help config`
    expected_output = <<-OUT
Commands:
    OUT

    expect(output).to eq(expected_output)
  end
end
      EOS

      expect(::File.read('spec/integration/config/set_spec.rb')).to eq <<-EOS
RSpec.describe "`cli-app config set` command", type: :cli do
  it "executes `cli-app config help set` command successfully" do
    output = `cli-app config help set`
    expected_output = <<-OUT
Usage:
  cli-app set

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
      EOS

      expect(::File.read('spec/unit/config/set_spec.rb')).to eq <<-EOS
require 'cli/app/commands/config/set'

RSpec.describe Cli::App::Commands::Config::Set do
  it "executes `config set` command successfully" do
    output = StringIO.new
    options = {}
    command = Cli::App::Commands::Config::Set.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\\n")
  end
end
      EOS
    end
  end
end
