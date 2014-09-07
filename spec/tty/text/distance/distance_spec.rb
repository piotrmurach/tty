# encoding: utf-8

require 'spec_helper'

describe TTY::Text::Distance, '#distance' do
  let(:object) { described_class.new(*strings) }

  subject(:distance) { object.distance }

  context 'when nil' do
    let(:strings) { [nil, nil] }

    it { is_expected.to eql(0) }
  end

  context 'when empty' do
    let(:strings) { ['', ''] }

    it { is_expected.to eql(0) }
  end

  context 'with one non empty' do
    let(:strings) { ['abc', ''] }

    it { is_expected.to eql(3) }
  end

  context 'when single char' do
    let(:strings) { ['a', 'abc'] }

    it { is_expected.to eql(2) }
  end

  context 'when similar' do
    let(:strings) { ['abc', 'abc'] }

    it { is_expected.to eql(0) }
  end

  context 'when similar' do
    let(:strings) { ['abc', 'acb'] }

    it { is_expected.to eql(1) }
  end

  context 'when end similar' do
    let(:strings) { ['saturday', 'sunday'] }

    it { is_expected.to eql(3) }
  end

  context 'when contain similar' do
    let(:strings) { ['which', 'witch'] }

    it { is_expected.to eql(2) }
  end

  context 'when prefix' do
    let(:strings) { ['sta', 'status'] }

    it { is_expected.to eql(3) }
  end

  context 'when similar' do
    let(:strings) { ['smellyfish','jellyfish'] }

    it { is_expected.to eql(2) }
  end

  context 'when unicode' do
    let(:strings) { ['マラソン五輪代表', 'ララソン五輪代表'] }

    it { is_expected.to eql(1) }
  end
end
