RSpec.describe 'teletype add --desc --args', type: :cli do
  it "adds command with description and custom arguments" do
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
      command = "teletype add config --desc='Set and get configuration option' --args=arg1 arg2"

      _, err, status = Open3.capture3(command)

      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      expect(::File.read('lib/newcli/cli.rb')).to eq <<-EOS
require 'thor'

module Newcli
  class CLI < Thor

    desc 'config ARG1 ARG2', 'Set and get configuration option'
    def config(arg1, arg2)
      if options[:help]
        invoke :help, ['config']
      else
        require_relative 'commands/config'
        Newcli::Commands::Config.new(arg1, arg2, options).execute
      end
    end
  end
end
      EOS

      expect(::File.read('lib/newcli/commands/config.rb')).to eq <<-EOS
# frozen_string_literal: true

require_relative '../command'

module Newcli
  module Commands
    class Config < Newcli::Command
      def initialize(arg1, arg2, options)
        @arg1 = arg1
        @arg2 = arg2
        @options = options
      end

      def execute
        # Command logic goes here ...
      end
    end
  end
end
      EOS
    end
  end

  it "adds command with variadic number of arguments" do
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
      command = "teletype add config --args=arg1 *names"

      _, err, status = Open3.capture3(command)

      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      expect(::File.read('lib/newcli/cli.rb')).to eq <<-EOS
require 'thor'

module Newcli
  class CLI < Thor

    desc 'config ARG1 NAMES...', 'Command description...'
    def config(arg1, *names)
      if options[:help]
        invoke :help, ['config']
      else
        require_relative 'commands/config'
        Newcli::Commands::Config.new(arg1, names, options).execute
      end
    end
  end
end
      EOS

      expect(::File.read('lib/newcli/commands/config.rb')).to eq <<-EOS
# frozen_string_literal: true

require_relative '../command'

module Newcli
  module Commands
    class Config < Newcli::Command
      def initialize(arg1, names, options)
        @arg1 = arg1
        @names = names
        @options = options
      end

      def execute
        # Command logic goes here ...
      end
    end
  end
end
      EOS
    end
  end

  it "adds subcommand with description and custom arguments" do
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
      command = "teletype add config set --desc='Set configuration option' --args=name 'value = nil'"

      _, err, status = Open3.capture3(command)

      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      expect(::File.read('lib/newcli/cli.rb')).to eq <<-EOS
require 'thor'

module Newcli
  class CLI < Thor

    require_relative 'commands/config'
    register Newcli::Commands::Config, 'config', 'config [SUBCOMMAND]', 'Set configuration option'
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

      desc 'set NAME VALUE', 'Set configuration option'
      def set(name, value = nil)
        if options[:help]
          invoke :help, ['set']
        else
          require_relative 'config/set'
          Newcli::Commands::Config::Set.new(name, value, options).execute
        end
      end
    end
  end
end
      EOS

      expect(::File.read('lib/newcli/commands/config/set.rb')).to eq <<-EOS
# frozen_string_literal: true

require_relative '../../command'

module Newcli
  module Commands
    class Config
      class Set < Newcli::Command
        def initialize(name, value, options)
          @name = name
          @value = value
          @options = options
        end

        def execute
          # Command logic goes here ...
        end
      end
    end
  end
end
      EOS
    end
  end
end
