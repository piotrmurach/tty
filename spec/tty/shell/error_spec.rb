# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Shell, '#error' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }

  subject(:shell) { TTY::Shell.new(input, output) }

  after { output.rewind }

  it 'displays one message' do
    shell.error "Nothing is fine!"
    expect(output.string).to eql "\e[31mNothing is fine!\e[0m\n"
  end

  it 'displays many messages' do
    shell.error "Nothing is fine!", "All is broken!"
    expect(output.string).to eql "\e[31mNothing is fine!\e[0m\n\e[31mAll is broken!\e[0m\n"
  end

  it 'displays message with option' do
    shell.error "Nothing is fine!", :newline => false
    expect(output.string).to eql "\e[31mNothing is fine!\e[0m"
  end

end # error
