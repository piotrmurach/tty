# encoding: utf-8

require 'spec_helper'

describe TTY::Plugin, '#load!' do
  let(:gem)    { Gem::Specification.new('tty-console', '3.1.3')}
  let(:name)   { 'console'}
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }

  subject(:plugin) { described_class.new(name, gem) }

  context 'when gem unsuccessfully loaded' do
    before { allow(Kernel).to receive(:require) { raise LoadError } }

    it 'fails to load the gem' do
      allow(TTY.shell).to receive(:error)
      subject.load!
      expect(TTY.shell).to have_received(:error).with(/Unable to load plugin tty-console./)
    end
  end

  context 'when gem unsuccessfully required' do
    before { allow(Kernel).to receive(:require) { raise StandardError } }

    it 'fails to require the gem' do
      allow(TTY.shell).to receive(:error)
      subject.load!
      expect(TTY.shell).to have_received(:error).with(/Unable to load plugin tty-console./)
    end
  end
end
