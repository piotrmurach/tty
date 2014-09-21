# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question, '#read_char' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  it 'reads single character' do
    input << "abcde"
    input.rewind
    q = shell.ask("What is your favourite letter?")
    expect(q.read_char).to eql "a"
  end
end
