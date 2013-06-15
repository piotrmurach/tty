# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Plugins, '#find' do
  let(:object)  { described_class }
  let(:tty_gem) { Gem::Specification.new('tty-console', '3.1.3')}
  let(:gem)     { Gem::Specification.new('thor', '1.1.4') }
  let(:gems)    { [gem, tty_gem] }

  before {
    Gem.stub(:refresh)
    Gem::Specification.stub(:each).and_yield(tty_gem).and_yield(gem)
  }

  subject { object.new }

  it 'inserts the tty gem only' do
    found = subject.find
    expect(found).to have(1).item
    expect(found.first.gem).to eql(tty_gem)
  end

  it 'retrieves only tty plugin' do
    subject.find
    expect(subject.names['console'].gem).to eql(tty_gem)
  end
end
