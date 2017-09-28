# encoding: utf-8

RSpec.describe 'teletype' do
  it "prints available commands and global options" do
    command = "bundle exec teletype"

    out = `#{command}`

    expect(out).to include <<-OUT
\e[0mCommands:
  teletype add COMMAND_NAME [OPTIONS]  # Add a command to the command line app.
  teletype help [COMMAND]              # Describe available commands or one specific command
  teletype new PROJECT_NAME [OPTIONS]  # Create a new command line app skeleton.
  teletype version                     # TTY version

Options:
      [--no-color]                 # Disable colorization in output.
  -r, [--dry-run], [--no-dry-run]  # Run but do not make any changes.
      [--debug], [--no-debug]      # Run with debug logging.
OUT
  end
end
