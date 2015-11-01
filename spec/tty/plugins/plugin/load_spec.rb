# encoding: utf-8

require 'spec_helper'

describe TTY::Plugin, '#load!' do
  let(:gem)    { Gem::Specification.new('tty-console', '3.1.3')}
  let(:name)   { 'console'}

  subject(:plugin) { described_class.new(name, gem) }

  it 'fails to load the gem' do
    allow(Kernel).to receive(:require) { raise LoadError }
    expect {
      plugin.load!
    }.to output(/Unable to load plugin tty-console./).to_stdout
  end

  it 'fails to require the gem' do
    allow(Kernel).to receive(:require) { raise StandardError }
    expect {
      plugin.load!
    }.to output(/Unable to load plugin tty-console./).to_stdout
  end
end
