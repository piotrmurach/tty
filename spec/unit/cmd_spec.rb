# frozen_string_literal: true

require "tty/cmd"

RSpec.describe TTY::Cmd do
  describe "#command_path" do
    it "finds path for a top level command " do
      stub_const("Commands::FooBarCommand", Class.new(TTY::Cmd))
      expect(Commands::FooBarCommand.new.command_path).to eq("foo_bar")
    end

    it "finds path for a nested command" do
      stub_const("Commands::BarSubCommand::FooCommand", Class.new(TTY::Cmd))
      expect(Commands::BarSubCommand::FooCommand.new.command_path).
        to eq("bar_sub_command/foo")
    end
  end
end
