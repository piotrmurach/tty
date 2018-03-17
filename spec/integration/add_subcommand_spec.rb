RSpec.describe 'teletype add subcommad', type: :cli do
  it "adds a new subcommand" do
    app_name = tmp_path('newcli')
    silent_run("teletype new #{app_name} --test rspec")

    output = <<-OUT
      create  spec/integration/config_spec.rb
      create  spec/integration/config/add_spec.rb
      create  lib/newcli/commands/config.rb
      inject  lib/newcli/cli.rb
      inject  lib/newcli/commands/config.rb
    OUT

    within_dir(app_name) do
      command = "teletype add config add --no-color"

      out, err, status = Open3.capture3(command)

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

      desc 'add', 'Command description...'
      def add(*)
        if options[:help]
          invoke :help, ['add']
        else
          require_relative 'config/add'
          Newcli::Commands::Config::Add.new(options).execute
        end
      end
    end
  end
end
      EOS

      #
      # TODO: expectations for subcommand 'lib/newcli/commands/config/add.rb'
      #

      # test setup
      #
      expect(::File.read('spec/integration/config_spec.rb')).to eq <<-EOS
RSpec.describe Newcli::Commands::Config do
  it "executes the command successfully" do
    output = `newcli config`
    expect(output).to eq("EXPECTED")
  end
end
      EOS

      expect(::File.read('spec/integration/config/add_spec.rb')).to eq <<-EOS
RSpec.describe Newcli::Commands::Config::Add do
  it "executes the command successfully" do
    output = `newcli config add`
    expect(output).to eq("EXPECTED")
  end
end
      EOS
    end
  end
end
