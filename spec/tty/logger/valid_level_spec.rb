# encoding: utf-8

require 'spec_helper'

describe TTY::Logger, '#valid_level?' do
  let(:object) { described_class }

  subject { object.valid_level?(level) }

  context 'when level is nil' do
    let(:level) { nil }

    it { is_expected.to eq(false) }
  end

  context 'when level is non numeric' do
    let(:level) { 'a' }

    it { is_expected.to eq(false) }
  end

  context 'when level is not a valid number' do
    let(:level) { -1 }

    it { is_expected.to eq(false) }
  end

  context 'when level is valid number' do
    let(:level) { 0 }

    it { is_expected.to eq(true) }
  end
end
