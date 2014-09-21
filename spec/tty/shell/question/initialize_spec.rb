# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question, '#initialize' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }
  let(:message) { 'Do you like me?' }

  subject(:question) { described_class.new shell }

  it { expect(question.required?).to eq(false) }

  it { expect(question.echo).to eq(true) }

  it { expect(question.mask).to eq(false) }

  it { expect(question.character).to eq(false) }

  it { expect(question.modifier).to be_kind_of(TTY::Shell::Question::Modifier) }

  it { expect(question.validation).to be_kind_of(TTY::Shell::Question::Validation) }
end # initialize
