# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Statement, '#new' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  subject(:statement) { described_class.new }

  it { expect(statement.newline).to eq(true) }

  it { expect(statement.color).to be_nil }
end
