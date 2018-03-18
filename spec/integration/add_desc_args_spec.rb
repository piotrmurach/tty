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

      expect(::File.read('lib/newcli/commands/config.rb')).to eq <<-EOS
# frozen_string_literal: true

require_relative '../cmd'

module Newcli
  module Commands
    class Config < Newcli::Cmd
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
    end
  end
end
