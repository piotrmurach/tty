RSpec.describe "`teletype add --desc --args` command", type: :cli do
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
      command = "teletype add config --test rspec --desc='Set and get configuration option' --args=arg1 arg2 --no-color"

      out, err, status = Open3.capture3(command)

      expect(out).to match <<-OUT
      create  spec/integration/config_spec.rb
      create  spec/unit/config_spec.rb
      create  lib/newcli/commands/config.rb
      create  lib/newcli/templates/config/.gitkeep
      inject  lib/newcli/cli.rb
      OUT
      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      expect(::File.read('lib/newcli/cli.rb')).to eq <<-EOS
require 'thor'

module Newcli
  class CLI < Thor

    desc 'config ARG1 ARG2', 'Set and get configuration option'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
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

      def execute(input: $stdin, output: $stdout)
        # Command logic goes here ...
        output.puts "OK"
      end
    end
  end
end
      EOS

      # test setup
      #
      expect(::File.read('spec/integration/config_spec.rb')).to eq <<-EOS
RSpec.describe "`newcli config` command", type: :cli do
  it "executes `newcli help config` command successfully" do
    output = `newcli help config`
    expect(output).to eq <<-OUT
Usage:
  newcli config ARG1 ARG2

Options:
  -h, [--help], [--no-help]  # Display usage information

Set and get configuration option
    OUT
  end
end
      EOS

      expect(::File.read('spec/unit/config_spec.rb')).to eq <<-EOS
require 'newcli/commands/config'

RSpec.describe Newcli::Commands::Config do
  it "executes `config` command successfully" do
    output = StringIO.new
    arg1 = nil
    arg2 = nil
    options = {}
    command = Newcli::Commands::Config.new(arg1, arg2, options)

    command.execute(output: output)

    expect(output.string).to eq("OK\\n")
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
      command = "teletype add config --args=arg1 *names --test=minitest --no-color"

      out, err, status = Open3.capture3(command)

      expect(out).to match <<-OUT
      create  test/integration/config_test.rb
      create  test/unit/config_test.rb
      create  lib/newcli/commands/config.rb
      create  lib/newcli/templates/config/.gitkeep
      inject  lib/newcli/cli.rb
      OUT
      expect(err).to eq('')
      expect(status.exitstatus).to eq(0)

      expect(::File.read('lib/newcli/cli.rb')).to eq <<-EOS
require 'thor'

module Newcli
  class CLI < Thor

    desc 'config ARG1 NAMES...', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
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

      def execute(input: $stdin, output: $stdout)
        # Command logic goes here ...
        output.puts "OK"
      end
    end
  end
end
      EOS

      # test/integration/config_test.rb
      #
      expect(::File.read('test/integration/config_test.rb')).to eq <<-EOS
require 'test_helper'
require 'newcli/commands/config'

class Newcli::Commands::ConfigTest < Minitest::Test
  def test_executes_newcli_help_config_command_successfully
    output = `newcli help config`
    expected_output = <<-OUT
Usage:
  newcli config ARG1 NAMES...

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    assert_equal expected_output, output
  end
end
      EOS

      # test/unit/config_test.rb
      #
      expect(::File.read('test/unit/config_test.rb')).to eq <<-EOS
require 'test_helper'
require 'newcli/commands/config'

class Newcli::Commands::ConfigTest < Minitest::Test
  def test_executes_config_command_successfully
    output = StringIO.new
    arg1 = nil
    names = nil
    options = {}
    command = Newcli::Commands::Config.new(arg1, names, options)

    command.execute(output: output)

    assert_equal "OK\\n", output.string
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

      desc 'set NAME [VALUE]', 'Set configuration option'
      method_option :help, aliases: '-h', type: :boolean,
                           desc: 'Display usage information'
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

        def execute(input: $stdin, output: $stdout)
          # Command logic goes here ...
          output.puts "OK"
        end
      end
    end
  end
end
      EOS
    end
  end
end
