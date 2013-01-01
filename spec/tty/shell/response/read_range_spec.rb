# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Shell::Question, '#read_range' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  subject {
    input << value
    input.rewind
    shell.ask("Which age group?").read_range
  }

  context 'with valid range' do
    let(:value) { "20-30" }

    it { expect(subject).to be_kind_of Range }

    it { expect(subject).to eql (20..30) }
  end

  context 'with invalid range' do
    let(:value) { "abcd" }

    it { expect { subject }.to raise_error(ArgumentError) }
  end
end # read_range
