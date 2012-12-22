# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Shell, '#ask' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }

  subject(:shell) { TTY::Shell.new(input, output) }

  it 'prints message' do
    shell.ask "What is your name?"
    expect(output.string).to eql "What is your name?\n"
  end

  it 'prints an empty message ' do
    shell.ask ""
    expect(output.string).to eql "\n"
  end

  it 'prints an empty message and returns nil if EOF is sent to stdin' do
    input << nil
    input.rewind
    q = shell.ask ""
    expect(q.read).to eql nil
  end

  it 'asks a question with block' do
    input << ''
    input.rewind
    q = shell.ask "What is your name?" do
      default 'Piotr'
    end
    expect(q.read).to eql "Piotr"
  end

  context 'yes?' do
    it 'agrees' do
      input << 'yes'
      input.rewind
      expect(shell.yes?("Are you a human?")).to be_true
    end

    it 'disagrees' do
      input << 'no'
      input.rewind
      expect(shell.yes?("Are you a human?")).to be_false
    end
  end

  context 'no?' do
    it 'agrees' do
      input << 'no'
      input.rewind
      expect(shell.no?("Are you a human?")).to be_true
    end

    it 'disagrees' do
      input << 'yes'
      input.rewind
      expect(shell.no?("Are you a human?")).to be_false
    end
  end

end
