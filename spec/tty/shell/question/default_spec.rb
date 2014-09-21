# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question, '#default' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  it 'uses default value' do
    name = 'Anonymous'
    q = shell.ask("What is your name?").default(name)
    answer = q.read
    expect(answer).to eq(name)
  end

  it 'uses default value in block' do
    name = 'Anonymous'
    q = shell.ask "What is your name?" do
      default name
    end
    answer = q.read
    expect(answer).to eq(name)
  end
end # default
