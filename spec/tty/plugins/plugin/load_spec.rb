# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Plugin, '#load!' do
  let(:gem) { Gem::Specification.new('tty-console', '3.1.3')}
  let(:name) { 'console'}
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }

  let(:object) { described_class.new(name, gem) }

  subject { object.load! }

  before {
    TTY.shell(input, output)
  }

  it 'fails to require the gem' do
    subject
    expect(output.string).to match("Unable to load plugin tty-console.")
  end
end
