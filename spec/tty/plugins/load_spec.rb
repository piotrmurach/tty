# encoding: utf-8

require 'spec_helper'

describe TTY::Plugins, '#load' do
  let(:object)  { described_class }
  let(:plugin)  { double(:plugin, :enabled? => false) }
  let(:plugins) { [plugin, plugin]}

  subject { object.new }

  before { allow(subject).to receive(:plugins).and_return(plugins) }

  it "activates all plugins" do
    allow(plugin).to receive(:load!)
    subject.load
    expect(plugin).to have_received(:load!).twice()
  end
end
