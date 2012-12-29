# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Shell::Question, '#modify' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  it 'preserves answer for unkown modification' do
    input << 'piotr'
    input.rewind
    q = shell.ask("What is your name?").modify(:none)
    expect(q.read_string).to eql 'piotr'
  end

  it 'converts to upper case' do
    input << 'piotr'
    input.rewind
    q = shell.ask("What is your name?").modify(:upcase)
    expect(q.read_string).to eql 'PIOTR'
  end

  it 'trims whitespace' do
    input << " Some   white\t   space\t \there!   \n"
    input.rewind
    q = shell.ask("Enter some text: ").modify(:trim)
    expect(q.read_string).to eql "Some   white\t   space\t \there!"
  end

  it 'collapses whitespace' do
    input << " Some   white\t   space\t \there!   \n"
    input.rewind
    q = shell.ask("Enter some text: ").modify(:collapse)
    expect(q.read_string).to eql " Some white space here! "
  end

  it 'strips and collapses whitespace' do
    input << " Some   white\t   space\t \there!   \n"
    input.rewind
    q = shell.ask("Enter some text: ").modify(:strip, :collapse)
    expect(q.read_string).to eql "Some white space here!"
  end
end
