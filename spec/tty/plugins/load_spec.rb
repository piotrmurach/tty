# encoding: utf-8

require 'spec_helper'

describe TTY::Plugins, '#load' do
  it "activates all plugins" do
    plugin = double(:plugin, :enabled? => false, :load! => true)
    plugins = TTY::Plugins.new
    allow(plugins).to receive(:plugins).and_return([plugin, plugin])

    plugins.load

    expect(plugin).to have_received(:load!).twice
  end
end
