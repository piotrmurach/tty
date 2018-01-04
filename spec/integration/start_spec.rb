RSpec.describe 'teletype' do
  xit "prints available commands and global options" do
    command = "teletype"

    out = `#{command}`

    expect(out).to eq(<<-OUT)
#{TTY::CLI.top_banner}Commands:
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
