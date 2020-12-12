# frozen_string_literal: true

RSpec.describe "teletype new namespaced", type: :sandbox do
  def ci_line(name)
    bundler_ver = Gem::Version.new(Bundler::VERSION)
    ver = Gem::Version.new("2.2.0")
    bundler_ver < ver ? "create  #{name}/.travis.yml\n      " : ""
  end

  it "generates cli application namespaced" do
    app_name = "cli-app"

    output = <<-OUT
Creating gem 'cli-app'...
      create  cli-app/Gemfile
      create  cli-app/lib/cli/app.rb
      create  cli-app/lib/cli/app/version.rb
      create  cli-app/cli-app.gemspec
      create  cli-app/Rakefile
      create  cli-app/README.md
      create  cli-app/bin/console
      create  cli-app/bin/setup
      create  cli-app/.gitignore
      #{ci_line("cli-app")}create  cli-app/.rspec
      create  cli-app/spec/spec_helper.rb
      create  cli-app/spec/cli/app_spec.rb
      append  cli-app/README.md
      inject  cli-app/cli-app.gemspec
      create  cli-app/lib/cli/app/cli.rb
      create  cli-app/lib/cli/app/command.rb
      create  cli-app/exe/cli-app
      create  cli-app/.editorconfig
      create  cli-app/LICENSE.txt
      create  cli-app/lib/cli/app/commands/.gitkeep
      create  cli-app/lib/cli/app/templates/.gitkeep
      create  cli-app/spec/integration/.gitkeep
      create  cli-app/spec/support/.gitkeep
      create  cli-app/spec/unit/.gitkeep
Initializing git repo in #{::File.expand_path(app_name)}

Your teletype project has been created successfully in directory "#{app_name}".

Before you can begin working, you'll need to modify the "#{app_name}.gemspec" file:
  * Replace all TODO: text with valid information (summary, description, etc)
  * Replace all metadata information (URIs, hosts) with valid URLs, or delete them
  * Uncomment any 'spec.add_dependency' lines for tty-* libs you plan on using

Then, you can run "teletype help" for more commands.
    OUT

    command = "teletype new #{app_name} --no-coc --no-color --license mit"

    out, err, status = Open3.capture3(command)

    expect(out).to include(output)
    expect(err).to eq("")
    expect(status.exitstatus).to eq(0)

    within_dir(app_name) do

      # exe/cli-app
      #
      expect(::File.read("exe/cli-app")).to eq(<<-EOS)
#!/usr/bin/env ruby
# frozen_string_literal: true

lib_path = File.expand_path('../lib', __dir__)
$:.unshift(lib_path) if !$:.include?(lib_path)
require 'cli/app/cli'

Signal.trap('INT') do
  warn(\"\\n\#{caller.join(\"\\n\")}: interrupted\")
  exit(1)
end

begin
  Cli::App::CLI.start
rescue Cli::App::CLI::Error => err
  puts \"ERROR: \#{err.message}\"
  exit 1
end
      EOS

      # lib/cli/app/cli.rb
      #
      expect(::File.read("lib/cli/app/cli.rb")).to eq(<<-EOS)
# frozen_string_literal: true

require "thor"

module Cli
  module App
    # Handle the application command line parsing
    # and the dispatch to various command objects
    #
    # @api public
    class CLI < Thor
      # Error raised by this runner
      Error = Class.new(StandardError)

      desc "version", "cli-app version"
      def version
        require_relative "version"
        puts \"v\#{Cli::App::VERSION}\"
      end
      map %w[--version -v] => :version
    end
  end
end
    EOS

      # lib/newcli/cmd.rb
      #
      expect(::File.read("lib/cli/app/command.rb")).to eq(<<-EOS)
# frozen_string_literal: true

module Cli
  module App
    class Command
      # Execute this command
      #
      # @api public
      def execute(*)
        raise(
          NotImplementedError,
          "\#{self.class}#\#{__method__} must be implemented"
        )
      end

      # Below are examples of how to integrate TTY components

      # The external commands runner
      #
      # @see http://www.rubydoc.info/gems/tty-command
      #
      # @api public
      # def command(**options)
      #   require "tty-command"
      #   TTY::Command.new(options)
      # end

      # The interactive prompt
      #
      # @see http://www.rubydoc.info/gems/tty-prompt
      #
      # @api public
      # def prompt(**options)
      #   require "tty-prompt"
      #   TTY::Prompt.new(options)
      # end
    end
  end
end
    EOS
    end
  end
end
