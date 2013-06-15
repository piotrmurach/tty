# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Plugins, '#load' do
  let(:object)  { described_class }
  let(:plugin) { stub(:plugin, :enabled? => false) }
  let(:plugins) { [plugin, plugin]}

  subject { object.new }

  before {
    subject.stub(:plugins).and_return(plugins)
  }

  it "activates all plugins" do
    plugin.should_receive(:load!).twice()
    subject.load
  end
end
