# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question, '#in' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  it 'reads number within range' do
    input << 8
    input.rewind
    q = shell.ask("How do you like it on scale 1-10").in('1-10')
    expect(q.read_int).to eql 8
  end

  it "reads number outside of range" do
    input << 12
    input.rewind
    q = shell.ask("How do you like it on scale 1-10").in('1-10')
    expect { q.read_int }.to raise_error(ArgumentError)
  end
end # in
