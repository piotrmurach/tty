# encoding: utf-8

RSpec.describe 'teletype new', type: :cli do

  it "generates cli application" do
    app_name = tmp_path('newcli')

    output = <<-OUT
Creating gem 'newcli'...
      create  tmp/newcli/Gemfile
      create  tmp/newcli/lib/newcli.rb
      create  tmp/newcli/lib/newcli/version.rb
      create  tmp/newcli/newcli.gemspec
      create  tmp/newcli/Rakefile
      create  tmp/newcli/README.md
      create  tmp/newcli/bin/console
      create  tmp/newcli/bin/setup
      create  tmp/newcli/.gitignore
      create  tmp/newcli/.travis.yml
      create  tmp/newcli/.rspec
      create  tmp/newcli/spec/spec_helper.rb
      create  tmp/newcli/spec/newcli_spec.rb
Initializing git repo in #{app_name}
      inject  tmp/newcli/newcli.gemspec
      create  tmp/newcli/lib/newcli/cli.rb
      create  tmp/newcli/exe/newcli
      create  tmp/newcli/LICENSE.txt
    OUT

    command = "bundle exec teletype new #{app_name} --no-coc --no-color --license mit"
    out, err, status = Open3.capture3(command)

    expect(out).to match(output)
    expect(err).to eq('')
    expect(status.exitstatus).to eq(0)

    within_dir(app_name) do

      # doesn't generate coc
      expect(::File.exist?('CODE_OF_CONDUCT.md')).to eq(false)

      # doesn't generate ext
      expect(::File.exist?("ext/newcli/extconf.rb")).to eq(false)

      expect(::File.read('LICENSE.txt')).to match(/The MIT License \(MIT\)/)

      # newcli.gemspec
      gemspec = ::File.read('newcli.gemspec')

      expect(gemspec).to match(/spec.license\s+= \"MIT\"/)

      expect(gemspec).to match(%r{
  spec.add_dependency "tty-color", "~> \d+.\d+.\d+"
  spec.add_dependency "tty-cursor", "~> \d+.\d+.\d+"
  spec.add_dependency "tty-command", "~> \d+.\d+.\d+"
  spec.add_dependency "tty-editor", "~> \d+.\d+.\d+"
  spec.add_dependency "tty-file", "~> \d+.\d+.\d+"
  spec.add_dependency "tty-pager", "~> \d+.\d+.\d+"
  spec.add_dependency "tty-platform", "~> \d+.\d+.\d+"
  spec.add_dependency "tty-progressbar", "~> \d+.\d+.\d+"
  spec.add_dependency "tty-prompt", "~> \d+.\d+.\d+"
  spec.add_dependency "tty-screen", "~> \d+.\d+.\d+"
  spec.add_dependency "tty-spinner", "~> \d+.\d+.\d+"
  spec.add_dependency "tty-table", "~> \d+.\d+.\d+"
  spec.add_dependency "tty-tree", "~> \d+.\d+.\d+"
  spec.add_dependency "tty-which", "~> \d+.\d+.\d+"
  spec.add_dependency "pastel", "~> \d+.\d+.\d+"
})

      # exe/newcli
      #
      expect(::File.read('exe/newcli')).to match(<<-EOS)
#!/usr/bin/env ruby

require 'bundler'
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
      expect(::File.read('lib/newcli/cli.rb')).to match(<<-EOS)
# frozen_string_literal: true
# encoding: utf-8

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
  end
end
      EOS

    end
  end

  it "generates C extensions boilerplate" do
    app_name = tmp_path('newcli')

    output = <<-OUT
      create  tmp/newcli/ext/newcli/extconf.rb
      create  tmp/newcli/ext/newcli/newcli.h
      create  tmp/newcli/ext/newcli/newcli.c
    OUT

    command = "bundle exec teletype new #{app_name} --ext --no-color --license mit"
    out, err, status = Open3.capture3(command)

    expect(out).to match(output)
    expect(err).to eq('')
    expect(status.exitstatus).to eq(0)

    within_dir(app_name) do
      expect(::File.exist?("ext/newcli/extconf.rb")).to eq(true)
    end
  end

  it "generates code of conduct file" do
    app_name = tmp_path('newcli')

    output = <<-OUT
      create  tmp/newcli/CODE_OF_CONDUCT.md
    OUT

    command = "bundle exec teletype new #{app_name} --coc --no-color --license mit"
    out, err, status = Open3.capture3(command)

    expect(out).to match(output)
    expect(err).to eq('')
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
    command = "bundle exec teletype new"
    out, err, status = Open3.capture3(command)
    expect([out, err, status.exitstatus]).to match_array([output, '', 1])
  end

  it "displays help" do
    output = <<-OUT
Usage:
  teletype new PROJECT_NAME [OPTIONS]

Options:
      [--ext], [--no-ext]          # Generate a boilerpalate for C extension.
      [--coc], [--no-coc]          # Generate a code of conduct file.
                                   # Default: true
  -f, [--force]                    # Overwrite existing files.
  -h, [--help=HELP]                # Display usage information.
  -l, [--license=mit]              # Generate a license file.
                                   # Possible values: agplv3, apache, gplv2, gplv3, lgplv3, mit, mplv2, custom
  -t, [--test=rspec]               # Generate a test setup.
                                   # Possible values: rspec, minitest
      [--no-color]                 # Disable colorization in output.
  -r, [--dry-run], [--no-dry-run]  # Run but do not make any changes.
      [--debug], [--no-debug]      # Run with debug logging.

Description:
  The 'teletype new' command creates a new command line application with a 
  default directory structure and configuration at the specified path.
    OUT

    command = "bundle exec teletype new --help"
    out, err, status = Open3.capture3(command)
    expect(out).to eq(output)
    expect(err).to eq('')
    expect(status.exitstatus).to eq(0)
  end
end
