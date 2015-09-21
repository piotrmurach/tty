# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question, '#argument' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell)  { TTY::Shell.new(input, output) }

  it 'requires value to be present with helper' do
    input << ''
    input.rewind
    q = shell.ask("What is your name?").argument(:required)
    expect { q.read }.to raise_error(ArgumentError)
  end

  it 'requires value to be present with option' do
    input << ''
    input.rewind
    q = shell.ask("What is your name?", required: true)
    expect { q.read }.to raise_error(ArgumentError)
  end

  it "doesn't require value to be present" do
    input << ''
    input.rewind
    q = shell.ask("What is your name?").argument(:optional)
    expect(q.read).to be_nil
  end
end
