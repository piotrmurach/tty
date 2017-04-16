# encoding: utf-8

RSpec.describe 'rtty' do
  xit "prints available commands and global options" do
    logo = <<-EOS
     ┏━━━┓
  ┏━┳╋┳┳━┻━━┓
  ┣━┫┗┫┗┳┳┳━┫
  ┃ ┃┏┫┏┫┃┃★┃
  ┃ ┗━┻━╋┓┃ ┃
  ┗━━━━━┻━┻━┛
EOS
    output = <<-OUT
\e[31m#{logo}\e[0m
Commands:
  rtty help [COMMAND]              # Describe available commands or one specific command
  rtty new PROJECT_NAME [OPTIONS]  # Create a new command line app skeleton.
  rtty version                     # tty version

Options:
      [--no-color]                 # Disable colorization in output.
  -r, [--dry-run], [--no-dry-run]  # Run but do not make any changes.
      [--debug], [--no-debug]      # Run with debug logging.

    OUT

    puts output.encoding

    command = "bundle exe rtty"
    out = `#{command}`
    puts out.encoding
    expect(out).to eq(output)
  end
end
