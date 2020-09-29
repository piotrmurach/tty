# frozen_string_literal: true

RSpec.describe "teletype new", type: :sandbox do
  it "generates cli application" do
    app_name = "newcli"

    output = <<-OUT
Creating gem 'newcli'...
      create  newcli/Gemfile
      create  newcli/lib/newcli.rb
      create  newcli/lib/newcli/version.rb
      create  newcli/newcli.gemspec
      create  newcli/Rakefile
      create  newcli/README.md
      create  newcli/bin/console
      create  newcli/bin/setup
      create  newcli/.gitignore
      create  newcli/.travis.yml
      create  newcli/.rspec
      create  newcli/spec/spec_helper.rb
      create  newcli/spec/newcli_spec.rb
      append  newcli/README.md
      inject  newcli/newcli.gemspec
      create  newcli/lib/newcli/cli.rb
      create  newcli/lib/newcli/command.rb
      create  newcli/exe/newcli
      create  newcli/LICENSE.txt
      create  newcli/lib/newcli/commands/.gitkeep
      create  newcli/lib/newcli/templates/.gitkeep
      create  newcli/spec/integration/.gitkeep
      create  newcli/spec/support/.gitkeep
      create  newcli/spec/unit/.gitkeep
Initializing git repo in #{::File.expand_path(app_name)}

Your teletype project has been created successfully in directory "#{app_name}".

Before you can begin working, you'll need to modify the "#{app_name}.gemspec" file:
  - Replace all TODO: text with valid information (summary, description, etc)
  - Replace all metadata information (URIs, hosts) with valid URLs, or delete them
  - Uncomment any 'spec.add_dependency' lines for tty-* libs you plan on using

Then, you can run "teletype help" for more commands.
    OUT

    command = "teletype new #{app_name} --no-coc --no-color --license mit --no-ext"
    out, err, status = Open3.capture3(command)

    expect(out).to match(output)
    expect(err).to eq("")
    expect(status.exitstatus).to eq(0)

    within_dir(app_name) do

      # doesn't generate coc
      expect(::File.exist?("CODE_OF_CONDUCT.md")).to eq(false)

      # doesn't generate ext
      expect(::File.exist?("ext/newcli/extconf.rb")).to eq(false)

      expect(::File.read("LICENSE.txt")).to match(/The MIT License \(MIT\)/)

      # newcli.gemspec
      gemspec = ::File.read("newcli.gemspec")

      expect(gemspec).to match(/spec.license\s+= \"MIT\"/)

      expect(gemspec).to match(%r{
  spec.require_paths = \["lib"\]

  spec.add_dependency "thor", "~> (\d+.?){2,3}"
  spec.add_dependency "pastel", "~> (\d+.?){2,3}"

  # Draw various frames and boxes in terminal window.
  # spec.add_dependency "tty-box", "~> (\d+.?){2,3}"

  # Terminal color capabilities detection.
  # spec.add_dependency "tty-color", "~> (\d+.?){2,3}"

  # Define, read and write app configurations.
  # spec.add_dependency "tty-config", "~> (\d+.?){2,3}"

  # Terminal cursor positioning, visibility and text manipulation.
  # spec.add_dependency "tty-cursor", "~> (\d+.?){2,3}"

  # Open a file or text in a terminal text editor.
  # spec.add_dependency "tty-editor", "~> (\d+.?){2,3}"

  # Terminal exit codes for humans and machines.
  # spec.add_dependency "tty-exit", "~> (\d+.?){2,3}"

  # File and directory manipulation utility methods.
  # spec.add_dependency "tty-file", "~> (\d+.?){2,3}"

  # Write text out to terminal in large stylized characters.
  # spec.add_dependency "tty-font", "~> (\d+.?){2,3}"

  # Hyperlinks in terminal.
  # spec.add_dependency "tty-link", "~> (\d+.?){2,3}"

  # A readable, structured and beautiful logging for the terminal.
  # spec.add_dependency "tty-logger", "~> (\d+.?){2,3}"

  # Convert a markdown document or text into a terminal friendly output.
  # spec.add_dependency "tty-markdown", "~> (\d+.?){2,3}"

  # Parser for command line arguments, keywords and options.
  # spec.add_dependency "tty-option", "~> (\d+.?){2,3}"

  # Draw pie charts in your terminal window.
  # spec.add_dependency "tty-pie", "~> (\d+.?){2,3}"

  # Detect different operating systems.
  # spec.add_dependency "tty-platform", "~> (\d+.?){2,3}"

  # A beautiful and powerful interactive command line prompt.
  # spec.add_dependency "tty-prompt", "~> (\d+.?){2,3}"

  # Terminal screen properties detection.
  # spec.add_dependency "tty-screen", "~> (\d+.?){2,3}"

  # A terminal spinner for tasks with non-deterministic time.
  # spec.add_dependency "tty-spinner", "~> (\d+.?){2,3}"

  # A flexible and intuitive table output generator.
  # spec.add_dependency "tty-table", "~> (\d+.?){2,3}"

  # Print directory or structured data in a tree like format.
  # spec.add_dependency "tty-tree", "~> (\d+.?){2,3}"

  # Platform independent implementation of Unix which command.
  # spec.add_dependency "tty-which", "~> (\d+.?){2,3}"
end})

      # exe/newcli
      #
      expect(::File.read("exe/newcli")).to eq(<<-EOS)
#!/usr/bin/env ruby
# frozen_string_literal: true

lib_path = File.expand_path('../lib', __dir__)
$:.unshift(lib_path) if !$:.include?(lib_path)
require 'newcli/cli'

Signal.trap('INT') do
  warn(\"\\n\#{caller.join(\"\\n\")}: interrupted\")
  exit(1)
end

begin
  Newcli::CLI.start
rescue Newcli::CLI::Error => err
  puts \"ERROR: \#{err.message}\"
  exit 1
end
      EOS

      # lib/newcli/cli.rb
      #
      expect(::File.read("lib/newcli/cli.rb")).to eq(<<-EOS)
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
  end
end
    EOS

      # lib/newcli/cmd.rb
      #
      expect(::File.read("lib/newcli/command.rb")).to eq(<<-EOS)
# frozen_string_literal: true

module Newcli
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
    EOS

      # Ensure executable
      #
      unless Gem.win_platform?
        expect(::File.executable?("exe/newcli")).to eq(true)
      end
    end
  end

  it "does not raise errors if app directory contains whitespace",
     unless: RSpec::Support::OS.windows? do
    app_path = "weird dir"
    ::FileUtils.mkdir_p(app_path)

    output = <<-OUT
Creating gem 'app'...
      create  app/Gemfile
      create  app/lib/app.rb
      create  app/lib/app/version.rb
      create  app/app.gemspec
      create  app/Rakefile
      create  app/README.md
      create  app/bin/console
      create  app/bin/setup
      create  app/.gitignore
      create  app/.travis.yml
      create  app/.rspec
      create  app/spec/spec_helper.rb
      create  app/spec/app_spec.rb
      append  app/README.md
      inject  app/app.gemspec
      create  app/lib/app/cli.rb
      create  app/lib/app/command.rb
      create  app/exe/app
      create  app/LICENSE.txt
      create  app/lib/app/commands/.gitkeep
      create  app/lib/app/templates/.gitkeep
      create  app/spec/integration/.gitkeep
      create  app/spec/support/.gitkeep
      create  app/spec/unit/.gitkeep
Initializing git repo in #{::File.expand_path(::File.join("weird dir", "app"))}

Your teletype project has been created successfully in directory "app".

Before you can begin working, you'll need to modify the "app.gemspec" file:
  - Replace all TODO: text with valid information (summary, description, etc)
  - Replace all metadata information (URIs, hosts) with valid URLs, or delete them
  - Uncomment any 'spec.add_dependency' lines for tty-* libs you plan on using

Then, you can run "teletype help" for more commands.
    OUT

    command = "teletype new app --no-coc --no-color --license mit --no-ext"

    within_dir(app_path) do
      out, _err, status = Open3.capture3(command)
      expect(out).to match(output)
      expect(status.exitstatus).to eq(0)
    end
  end

  it "generates C extensions boilerplate" do
    app_name = "newcli"

    output = <<-OUT
      create  newcli/ext/newcli/extconf.rb
      create  newcli/ext/newcli/newcli.h
      create  newcli/ext/newcli/newcli.c
    OUT

    command = "teletype new #{app_name} --ext --no-color --license mit"
    out, err, status = Open3.capture3(command)

    expect(out).to match(output)
    expect(err).to eq("")
    expect(status.exitstatus).to eq(0)

    within_dir(app_name) do
      expect(::File.exist?("ext/newcli/extconf.rb")).to eq(true)
    end
  end

  it "generates code of conduct file" do
    app_name = "newcli"

    output = <<-OUT
      create  newcli/CODE_OF_CONDUCT.md
    OUT

    command = "teletype new #{app_name} --coc --no-color --license mit"
    out, err, status = Open3.capture3(command)

    expect(out).to match(output)
    expect(err).to eq("")
    expect(status.exitstatus).to eq(0)

    within_dir(app_name) do
      expect(::File.exist?("CODE_OF_CONDUCT.md")).to eq(true)
    end
  end

  it "fails without cli name" do
    output = <<-OUT.unindent
      ERROR: 'teletype new' was called with no arguments
      Usage: 'teletype new PROJECT_NAME'\n
    OUT
    command = "teletype new"
    out, err, status = Open3.capture3(command)
    expect([out, err, status.exitstatus]).to match_array([output, "", 1])
  end

  it "displays help" do
    output = <<-OUT
Usage:
  teletype new PROJECT_NAME [OPTIONS]

Options:
  -a, [--author=name1 name2]       # Author(s) of this library
      [--ext], [--no-ext]          # Generate a boilerpalate for C extension
      [--coc], [--no-coc]          # Generate a code of conduct file
                                   # Default: true
  -f, [--force]                    # Overwrite existing files
  -h, [--help], [--no-help]        # Display usage information
  -l, [--license=mit]              # Generate a license file
                                   # Default: mit
                                   # Possible values: agplv3, apache, bsd2, bsd3, gplv2, gplv3, lgplv3, mit, mplv2, custom
  -t, [--test=rspec]               # Generate a test setup
                                   # Default: rspec
                                   # Possible values: rspec, minitest
      [--no-color]                 # Disable colorization in output
  -r, [--dry-run], [--no-dry-run]  # Run but do not make any changes
      [--debug], [--no-debug]      # Run in debug mode

Description:
  The 'teletype new' command creates a new command line application with a default
  directory structure and configuration at the specified path.

  The PROJECT_NAME will be the name for the directory that includes all the files
  and be the default binary name.

  Example: teletype new cli_app
    OUT

    command = "teletype new --help"
    out, err, status = Open3.capture3(command)
    expect(out).to eq(output)
    expect(err).to eq("")
    expect(status.exitstatus).to eq(0)
  end
end
