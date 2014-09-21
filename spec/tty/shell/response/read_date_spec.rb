# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question, '#read_date' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  it 'reads date' do
    input << "20th April 1887"
    input.rewind
    q = shell.ask("When were your born?")
    answer = q.read_date
    expect(answer).to be_kind_of Date
    expect(answer.day).to eql 20
    expect(answer.month).to eql 4
    expect(answer.year).to eql 1887
  end
end
