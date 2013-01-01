# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Shell::Question, '#character' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  it 'switches to character input' do
    input << "abcd"
    input.rewind
    q = shell.ask("Which one do you prefer a, b, c or d?").character(true)
    expect(q.read_string).to eql "abcd"
  end
end # character
