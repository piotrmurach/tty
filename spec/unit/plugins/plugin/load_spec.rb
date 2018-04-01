# encoding: utf-8

RSpec.describe TTY::Plugin, '#load!' do
  let(:gem)    { Gem::Specification.new('tty-console', '3.1.3')}

  it "loads a gem" do
    plugin = TTY::Plugin.new('tty-console', gem)
    allow(plugin).to receive(:require).with('tty-console').and_return(true)

    plugin.load!

    expect(plugin).to have_received(:require).once
  end

  it 'fails to load the gem' do
    plugin = TTY::Plugin.new('tty-console', gem)
    allow(plugin).to receive(:require) { raise LoadError }

    expect {
      plugin.load!
    }.to output(/Unable to load plugin tty-console./).to_stdout
  end

  it 'fails to require the gem' do
    plugin = TTY::Plugin.new('tty-console', gem)
    allow(plugin).to receive(:require) { raise StandardError }

    expect {
      plugin.load!
    }.to output(/require 'tty-console' failed with StandardError\n/).to_stdout
  end
end
