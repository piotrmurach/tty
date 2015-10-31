# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question, '#read_multiple' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  it 'reads multiple lines' do
    input << "First line\nSecond line\nThird line"
    input.rewind
    q = shell.ask("Provide description?")
    expect(q.read_multiple).to eq("First line\nSecond line\nThird line")
  end

  it 'terminates on empty lines' do
    input << "First line\n\nSecond line"
    input.rewind
    q = shell.ask("Provide description?")
    expect(q.read_multiple).to eq("First line\n")
  end
end
