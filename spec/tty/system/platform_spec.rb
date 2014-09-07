# encoding: utf-8

require 'spec_helper'

describe TTY::System, '#platform' do
  subject(:system) { described_class }

  it { is_expected.to respond_to(:windows?) }

  it { is_expected.to respond_to(:unix?) }

  it { is_expected.to respond_to(:which) }

  it { is_expected.to respond_to(:exists?) }

  it { is_expected.to respond_to(:editor) }

  context 'windows?' do
    it 'is on windows' do
      allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return('windows')
      expect(system.windows?).to eq(true)
    end

    it 'is on windows ignoring case' do
      allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return('Windows')
      expect(system.windows?).to eq(true)
    end

    it 'is not on windows' do
      allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return('unknown')
      expect(system.windows?).to eq(false)
    end
  end

  context 'unix?' do
    it 'checks if unix' do
      allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return('darwin')
      expect(system.unix?).to eq(true)
    end

    it 'checks if unix' do
      allow(RbConfig::CONFIG).to receive(:[]).with('host_os').and_return('unknown')
      expect(system.unix?).to eq(false)
    end
  end
end
