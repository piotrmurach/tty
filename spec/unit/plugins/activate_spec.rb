# frozen_string_literal: true

RSpec.describe TTY::Plugins, '#activate' do
  it "activates all plugins" do
    plugin = double(:plugin, :enabled? => false, :load! => true)
    plugins = TTY::Plugins.new
    allow(plugins).to receive(:plugins).and_return([plugin, plugin])

    plugins.activate

    expect(plugin).to have_received(:load!).twice
  end
end
