# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question, '#read_bool' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  it 'fails to read boolean' do
    input << 'invalid'
    input.rewind
    q = shell.ask("Do you read books?")
    expect { q.read_bool }.to raise_error(Necromancer::ConversionTypeError)
  end

  it 'reads negative boolean' do
    input << 'No'
    input.rewind
    q = shell.ask("Do you read books?")
    answer = q.read_bool
    expect(answer).to eql false
  end

  it 'reads positive boolean' do
    input << 'Yes'
    input.rewind
    q = shell.ask("Do you read books?")
    answer = q.read_bool
    expect(answer).to eql true
  end

  it 'reads single positive boolean' do
    input << 'y'
    input.rewind
    q = shell.ask("Do you read books?")
    answer = q.read_bool
    expect(answer).to eql true
  end
end
