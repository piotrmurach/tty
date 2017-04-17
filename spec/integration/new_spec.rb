# encoding: utf-8

RSpec.describe 'rtty new', type: :cli do

  it "generates cli application" do
    app_name = tmp_path('newcli')

    output = <<-OUT
Creating gem 'newcli'...
      create  tmp/newcli/Gemfile
      create  tmp/newcli/.gitignore
      create  tmp/newcli/lib/newcli.rb
      create  tmp/newcli/lib/newcli/version.rb
      create  tmp/newcli/newcli.gemspec
      create  tmp/newcli/Rakefile
      create  tmp/newcli/README.md
      create  tmp/newcli/bin/console
      create  tmp/newcli/bin/setup
      create  tmp/newcli/.travis.yml
      create  tmp/newcli/.rspec
      create  tmp/newcli/spec/spec_helper.rb
      create  tmp/newcli/spec/newcli_spec.rb
Initializing git repo in #{app_name}
      inject  tmp/newcli/newcli.gemspec
      create  tmp/newcli/LICENSE.txt
    OUT

    command = "bundle exec rtty new #{app_name} --no-coc --no-color --license mit"
    out, err, status = Open3.capture3(command)

    expect(out).to eq(output)
    expect(err).to eq('')
    expect(status.exitstatus).to eq(0)
  end

  it "fails without cli name" do
    output = <<-OUT.unindent
      ERROR: 'rtty new' was called with no arguments
      Usage: 'rtty new PROJECT_NAME'\n
    OUT
    command = "bundle exec rtty new"
    out, err, status = Open3.capture3(command)
    expect([out, err, status.exitstatus]).to match_array([output, '', 1])
  end

  it "displays help" do
    output = <<-OUT
Usage:
  rtty new PROJECT_NAME [OPTIONS]

Options:
      [--coc], [--no-coc]          # Generate a code of conduct file.
                                   # Default: true
  -f, [--force]                    # Overwrite existing files.
  -h, [--help=HELP]                # Display usage information.
  -l, [--license=mit]              # Generate a license file.
                                   # Possible values: agplv3, apache, gplv2, gplv3, lgplv3, mit, mplv2, none
  -t, [--test=rspec]               # Generate a test setup.
                                   # Possible values: rspec, minitest
      [--no-color]                 # Disable colorization in output.
  -r, [--dry-run], [--no-dry-run]  # Run but do not make any changes.
      [--debug], [--no-debug]      # Run with debug logging.

Description:
  The 'rtty new' command creates a new command line application with a default 
  directory structure and configuration at the specified path.
    OUT

    command = "bundle exec rtty new --help"
    out, err, status = Open3.capture3(command)
    expect(out).to eq(output)
    expect(err).to eq('')
    expect(status.exitstatus).to eq(0)
  end

  def run_within(cli_path, &block)
    Dir.chdir(cli_path, &block)
  end
end
