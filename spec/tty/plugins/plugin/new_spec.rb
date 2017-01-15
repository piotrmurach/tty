# encoding: utf-8

require 'spec_helper'

describe TTY::Plugin, '#new' do
  let(:gem)  { Gem::Specification.new('tty-console', '3.1.3')}

  subject(:plugin) { described_class.new('tty-console', gem) }

  it { expect(plugin.name).to eq('tty-console') }

  it { expect(plugin.gem).to eq(gem) }

  it { expect(plugin.enabled?).to eq(false) }
end
