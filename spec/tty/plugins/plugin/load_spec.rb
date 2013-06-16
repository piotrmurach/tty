# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Plugin, '#load!' do
  let(:gem) { Gem::Specification.new('tty-console', '3.1.3')}
  let(:name) { 'console'}
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }

  subject { described_class.new(name, gem) }

  context 'when gem unsuccessfully loaded' do
    before { Kernel.stub(:require) { raise LoadError } }

    it 'fails to load the gem' do
      TTY.shell.should_receive(:error).with(/Unable to load plugin tty-console./)
      subject.load!
    end
  end

  context 'when gem unsuccessfully required' do
    before { Kernel.stub(:require) { raise StandardError } }

    it 'fails to require the gem' do
      TTY.shell.should_receive(:error).with(/Unable to load plugin tty-console./)
      subject.load!
    end
  end
end
