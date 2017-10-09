# encoding: utf-8

RSpec.describe 'teletype add subcommad', type: :cli do
  it "adds a new subcommand" do
    app_name = tmp_path('newcli')
    silent_run("bundle exec teletype new #{app_name}")

    output = <<-OUT
      create  lib/newcli/commands/config.rb
      inject  lib/newcli/cli.rb
      inject  lib/newcli/commands/config.rb
    OUT

    within_dir(app_name) do
      command = "bundle exec teletype add config add --no-color"

      out, err, status = Open3.capture3(command)

      expect(out).to include(output)
      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

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

    require_relative 'commands/config'
    register Newcli::Commands::Config, 'config', 'config [SUBCOMMAND]', 'Command description...'
  end
end
      EOS

      expect(::File.read('lib/newcli/commands/config.rb')).to eq <<-EOS
# encoding: utf-8
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
    end
  end
end
