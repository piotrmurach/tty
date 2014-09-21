# encoding: utf-8

require 'spec_helper'

describe TTY::Coercer::Range, '#coerce' do

  subject { described_class.coerce(value) }

  context 'with empty' do
    let(:value) { '' }

    it { expect { subject }.to raise_error(TTY::InvalidArgument) }
  end

  context 'with 1' do
    let(:value) { '1' }

    it { is_expected.to eq(1..1) }
  end

  context 'with 1..10' do
    let(:value) { '1..10' }

    it { is_expected.to eq(1..10) }
  end

  context 'with 1-10' do
    let(:value) { '1-10' }

    it { is_expected.to eq(1..10) }
  end

  context 'with 1,10' do
    let(:value) { '1,10' }

    it { is_expected.to eq(1..10) }
  end

  context 'with 1...10' do
    let(:value) { '1...10'}

    it { is_expected.to eq(1...10) }
  end

  context 'with -1..10' do
    let(:value) { '-1..10' }

    it { is_expected.to eq(-1..10) }
  end

  context 'with 1..-10' do
    let(:value) { '1..-10' }

    it { is_expected.to eq(1..-10) }
  end

  context 'with a..z' do
    let(:value) { 'a..z' }

    it { is_expected.to eq('a'..'z')}
  end

  context 'with a-z' do
    let(:value) { 'a-z' }

    it { is_expected.to eq('a'..'z')}
  end

  context 'with A..Z' do
    let(:value) { 'A..Z' }

    it { is_expected.to eq('A'..'Z')}
  end
end # coerce
