# encoding: utf-8

require 'spec_helper'

describe TTY::Shell, '#say' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:color)  { Pastel.new(enabled: true) }

  subject(:shell) { TTY::Shell.new(input, output) }

  before { allow(Pastel).to receive(:new).and_return(color) }

  after { output.rewind }

  it 'prints an empty message' do
    shell.say ""
    expect(output.string).to eql ""
  end

  context 'with new line' do
    it 'prints a message with newline' do
      shell.say "Hell yeah!\n"
      expect(output.string).to eql "Hell yeah!\n"
    end

    it 'prints a message with implicit newline' do
      shell.say "Hell yeah!\n"
      expect(output.string).to eql "Hell yeah!\n"
    end

    it 'prints a message with newline within text' do
      shell.say "Hell\n yeah!"
      expect(output.string).to eql "Hell\n yeah!\n"
    end

    it 'prints a message with newline within text and blank space' do
      shell.say "Hell\n yeah! "
      expect(output.string).to eql "Hell\n yeah! "
    end

    it 'prints a message without newline' do
      shell.say "Hell yeah!", newline: false
      expect(output.string).to eql "Hell yeah!"
    end
  end

  context 'with tab or space' do
    it 'prints ' do
      shell.say "Hell yeah!\t"
      expect(output.string).to eql "Hell yeah!\t"
    end
  end

  context 'with color' do
    it 'prints message with ansi color' do
      shell.say "Hell yeah!", color: :green
      expect(output.string).to eql "\e[32mHell yeah!\e[0m\n"
    end

    it 'prints message with ansi color without newline' do
      shell.say "Hell yeah! ", color: :green
      expect(output.string).to eql "\e[32mHell yeah! \e[0m"
    end
  end

end # say
