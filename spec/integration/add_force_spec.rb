# frozen_string_literal: true

RSpec.describe "`teletype add --force` command", type: :sandbox do
  it "forces adding already existing command" do
    app_path = "newcli"
    cli_template = <<-EOS
require 'thor'

module Newcli
  class CLI < Thor
    desc 'config', 'Set and unset configuration information'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    def config(*)
      if options[:help]
      else
        require_relative 'commands/config'
        Newcli::Commands::Config.new(options).execute
      end
    end
  end
end
    EOS

    config_template = <<-EOS
require_relative '../command'

module Newcli
  module Commands
    class Config < Newcli::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        puts 'config command'
      end
    end
  end
end
    EOS

    dir = {
      app_path => [
        "lib" => [
          "newcli" => [
            ["cli.rb", cli_template],
            "commands" => [
              ["config.rb", config_template]
            ]
          ]
        ],
        "spec" => [
          "integration" => [
            "config_spec.rb"
          ]
        ]
      ]
    }
    ::TTY::File.create_dir(dir, verbose: false)

    output = <<-OUT
       force  spec/integration/config_spec.rb
      create  spec/unit/config_spec.rb
       force  lib/newcli/commands/config.rb
      create  lib/newcli/templates/config/.gitkeep
    OUT

    within_dir(app_path) do
      command = "teletype add config --no-color --force"

      out, err, status = Open3.capture3(command)

      expect(out).to eq(output)
      expect(err).to eq("")
      expect(status.exitstatus).to eq(0)

      expect(::File.read("lib/newcli/commands/config.rb")).to eq <<-EOS
# frozen_string_literal: true

require_relative '../command'

module Newcli
  module Commands
    class Config < Newcli::Command
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
      EOS
    end
  end
end
