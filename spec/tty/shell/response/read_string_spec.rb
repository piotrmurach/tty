# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question, '#initialize' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell)  { TTY::Shell.new(input, output) }

  it 'reads string' do
    name = "Piotr"
    input << name
    input.rewind
    q = shell.ask("What is your name?")
    answer = q.read_string
    expect(answer).to be_kind_of String
    expect(answer).to eql name
  end
end
