# encoding: utf-8

require 'spec_helper'

describe TTY::Plugin, '#new' do
  let(:gem)  { Gem::Specification.new('tty-console', '3.1.3')}
  let(:name) { 'console'}

  subject(:plugin) { described_class.new(name, gem) }

  it { expect(plugin.name).to eq(name) }

  it { expect(plugin.gem).to eq(gem) }

  it { expect(plugin.enabled).to eq(false) }

  it { expect(plugin.gem_name).to eq("tty-#{name}") }
end
