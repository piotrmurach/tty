# encoding: utf-8

require 'spec_helper'

describe TTY::Conversion::ArrayConverter do
  let(:object)    { described_class.new }
  let(:enumerable) { [] }

  subject { object.convert(enumerable) }

  context 'Array type' do
    it { is_expected.to eq(enumerable) }
  end

  context 'Hash type' do
    let(:enumerable) { {a: 1, b: 2} }

    it { is_expected.to include([:a, 1]) }

    it { is_expected.to include([:b, 2]) }
  end

  context 'responds to #to_ary' do
    let(:converted)  { [] }
    let(:enumerable) { double('Enumerable', to_ary: converted) }

    it { is_expected.to eq(converted) }
  end

  context 'does not respond to #to_ary' do
    let(:enumerable) { double('Enumerable') }

    it 'raises error' do
      expect { subject }.to raise_error(TTY::TypeError)
    end
  end
end
