# encoding: utf-8

require 'spec_helper'

describe TTY::Shell, '#warn' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:color)  { Pastel.new(enabled: true) }

  subject(:shell) { TTY::Shell.new(input, output) }

  before { allow(Pastel).to receive(:new).and_return(color) }

  after { output.rewind }

  it 'displays one message' do
    shell.warn "Careful young apprentice!"
    expect(output.string).to eql "\e[33mCareful young apprentice!\e[0m\n"
  end

  it 'displays many messages' do
    shell.warn "Careful there!", "It's dangerous!"
    expect(output.string).to eql "\e[33mCareful there!\e[0m\n\e[33mIt's dangerous!\e[0m\n"
  end

  it 'displays message with option' do
    shell.warn "Careful young apprentice!", newline: false
    expect(output.string).to eql "\e[33mCareful young apprentice!\e[0m"
  end
end # warn
