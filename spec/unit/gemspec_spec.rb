# frozen_string_literal: true

require "tty/gemspec"

RSpec.describe TTY::Gemspec, "#read" do
  it "reads gemspec's content" do
    gemspec_path = fixtures_path("foo-0.0.1.gemspec")
    gemspec = described_class.new
    gemspec.read(gemspec_path)

    expect(gemspec.content).to eq(::File.binread(gemspec_path))
    expect(gemspec.var_name).to eq("spec")

    expect(gemspec.pre_var_indent).to eq(2)
    expect(gemspec.post_var_indent).to eq(15)
  end

  it "formats gem dependencies" do
    gemspec = described_class.new
    gemspec.var_name = "spec"
    gemspec.pre_var_indent = 2

    expect(gemspec.format_gem_dependencies).to eq([
      %q{  spec.add_dependency "thor", "~> 1.0"},
      %q{  spec.add_dependency "pastel", "~> 0.8"},
      "",
      %q{  # Draw various frames and boxes in terminal window.},
      %q{  # spec.add_dependency "tty-box", "~> 0.6"},
      "",
      %q{  # Terminal color capabilities detection.},
      %q{  # spec.add_dependency "tty-color", "~> 0.5"},
      "",
      %q{  # Define, read and write app configurations.},
      %q{  # spec.add_dependency "tty-config", "~> 0.4"},
      "",
      %q{  # Terminal cursor positioning, visibility and text manipulation.},
      %q{  # spec.add_dependency "tty-cursor", "~> 0.7"},
      "",
      %q{  # Open a file or text in a terminal text editor.},
      %q{  # spec.add_dependency "tty-editor", "~> 0.6"},
      "",
      %q{  # Terminal exit codes for humans and machines.},
      %q{  # spec.add_dependency "tty-exit", "~> 0.1"},
      "",
      %q{  # File and directory manipulation utility methods.},
      %q{  # spec.add_dependency "tty-file", "~> 0.10"},
      "",
      %q{  # Write text out to terminal in large stylized characters.},
      %q{  # spec.add_dependency "tty-font", "~> 0.5"},
      "",
      %q{  # Hyperlinks in terminal.},
      %q{  # spec.add_dependency "tty-link", "~> 0.1"},
      "",
      %q{  # A readable, structured and beautiful logging for the terminal.},
      %q{  # spec.add_dependency "tty-logger", "~> 0.4"},
      "",
      %q{  # Convert a markdown document or text into a terminal friendly output.},
      %q{  # spec.add_dependency "tty-markdown", "~> 0.7"},
      "",
      %q{  # Parser for command line arguments, keywords and options.},
      %q{  # spec.add_dependency "tty-option", "~> 0.1"},
      "",
      %q{  # Draw pie charts in your terminal window.},
      %q{  # spec.add_dependency "tty-pie", "~> 0.4"},
      "",
      %q{  # Detect different operating systems.},
      %q{  # spec.add_dependency "tty-platform", "~> 0.3"},
      "",
      %q{  # A beautiful and powerful interactive command line prompt.},
      %q{  # spec.add_dependency "tty-prompt", "~> 0.22"},
      "",
      %q{  # Terminal screen properties detection.},
      %q{  # spec.add_dependency "tty-screen", "~> 0.8"},
      "",
      %q{  # A terminal spinner for tasks with non-deterministic time.},
      %q{  # spec.add_dependency "tty-spinner", "~> 0.9"},
      "",
      %q{  # A flexible and intuitive table output generator.},
      %q{  # spec.add_dependency "tty-table", "~> 0.12"},
      "",
      %q{  # Print directory or structured data in a tree like format.},
      %q{  # spec.add_dependency "tty-tree", "~> 0.4"},
      "",
      %q{  # Platform independent implementation of Unix which command.},
      %q{  # spec.add_dependency "tty-which", "~> 0.4"},
    ].join("\n"))
  end
end
