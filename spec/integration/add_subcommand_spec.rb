RSpec.describe "`teletype add` subcommad", type: :cli do
  it "adds a new subcommand" do
    app_name = tmp_path('newcli')
    silent_run("teletype new #{app_name} --test rspec")

    output = <<-OUT
      create  spec/integration/config_spec.rb
      create  spec/integration/config/set_spec.rb
      create  spec/unit/config/set_spec.rb
      create  lib/newcli/commands/config.rb
      create  lib/newcli/commands/config/set.rb
      create  lib/newcli/templates/config/set/.gitkeep
      inject  lib/newcli/cli.rb
      inject  lib/newcli/commands/config.rb
    OUT

    within_dir(app_name) do
      command_set = "teletype add config set --no-color"

      out, err, status = Open3.capture3(command_set)

      expect(out).to include(output)
      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

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

    require_relative 'commands/config'
    register Newcli::Commands::Config, 'config', 'config [SUBCOMMAND]', 'Command description...'
  end
end
      EOS

      expect(::File.read('lib/newcli/commands/config.rb')).to eq <<-EOS
# frozen_string_literal: true

require 'thor'

module Newcli
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
          Newcli::Commands::Config::Set.new(options).execute
        end
      end
    end
  end
end
      EOS

      # Subcommand `set`
      #
      expect(::File.read('lib/newcli/commands/config/set.rb')).to eq <<-EOS
# frozen_string_literal: true

require_relative '../../command'

module Newcli
  module Commands
    class Config
      class Set < Newcli::Command
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

      # test setup
      #
      expect(::File.read('spec/integration/config_spec.rb')).to eq <<-EOS
RSpec.describe "`newcli config` command", type: :cli do
  it "executes `config --help` command successfully" do
    output = `newcli config --help`
    expect(output).to eq <<-OUT
Commands:
    OUT
  end
end
      EOS

      expect(::File.read('spec/integration/config/set_spec.rb')).to eq <<-EOS
RSpec.describe "`newcli config set` command", type: :cli do
  it "executes `config set --help` command successfully" do
    output = `newcli config set --help`
    expect(output).to eq <<-OUT
Usage:
  newcli set

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT
  end
end
      EOS

      expect(::File.read('spec/unit/config/set_spec.rb')).to eq <<-EOS
require 'newcli/commands/config/set'

RSpec.describe Newcli::Commands::Config::Set do
  it "executes `set` command successfully" do
    output = StringIO.new
    options = {}
    command = Newcli::Commands::Config::Set.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\\n")
  end
end
      EOS

      command_get = "teletype add config get --no-color"

      out, err, status = Open3.capture3(command_get)

      expect(out).to include <<-OUT
      create  spec/integration/config/get_spec.rb
      create  spec/unit/config/get_spec.rb
      create  lib/newcli/commands/config/get.rb
      create  lib/newcli/templates/config/get/.gitkeep
      inject  lib/newcli/commands/config.rb
      OUT
      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)
    end
  end
end
