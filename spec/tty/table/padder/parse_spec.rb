# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Padder, '#parse' do
  let(:object) { described_class }

  subject { object.parse(value).padding }

  context 'when number' do
    let(:value) { 5 }

    it { expect(subject).to eq([5,5,5,5]) }
  end

  context 'when nil' do
    let(:value) { nil }

    it { expect(subject).to eq([]) }
  end

  context 'when 2-element array' do
    let(:value) { [2,3] }

    it { expect(subject).to eq([2,3,2,3]) }
  end

  context 'when 4-element array' do
    let(:value) { [1,2,3,4] }

    it { expect(subject).to eq([1,2,3,4]) }
  end

  context 'when unkown' do
    let(:value) { :unkown }

    it { expect { subject }.to raise_error }
  end
end
