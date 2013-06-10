# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Text::Distance, '#distance' do
  let(:object) { described_class.new(*strings) }

  subject { object.distance }

  context 'when nil' do
    let(:strings) { [nil, nil] }

    it { should eql(0) }
  end

  context 'when empty' do
    let(:strings) { ['', ''] }

    it { should eql(0) }
  end

  context 'with one non empty' do
    let(:strings) { ['abc', ''] }

    it { should eql(3) }
  end

  context 'when similar' do
    let(:strings) { ['abc', 'abc'] }

    it { should eql(0) }
  end

  context 'when similar' do
    let(:strings) { ['abc', 'acb'] }

    it { should eql(1) }
  end

  context 'when end similar' do
    let(:strings) { ['saturday', 'sunday'] }

    it { should eql(3) }
  end

  context 'when contain similar' do
    let(:strings) { ['which', 'witch'] }

    it { should eql(2) }
  end

  context 'when similar' do
    let(:strings) { ['smellyfish','jellyfish'] }

    it { should eql(2) }
  end

  context 'when unicode' do
    let(:strings) { ['マラソン五輪代表', 'ララソン五輪代表'] }

    it { should eql(1) }
  end
end
