# encoding: utf-8

require 'spec_helper'

describe TTY::Conversion::IntegerConverter, '#convert' do
  let(:object) { described_class.new }
  let(:strict) { true }

  subject(:converter) { object.convert(value, strict) }

  context 'with empty' do
    let(:value) { '' }

    it { expect { subject }.to raise_error(TTY::InvalidArgument) }
  end

  context 'with 1 as string' do
    let(:value) { '1' }

    it { is_expected.to eql 1 }
  end

  context 'with float' do
    let(:value) { 1.2 }

    it { expect { subject }.to raise_error(TTY::InvalidArgument) }
  end

  context 'with float not strict' do
    let(:value) { 1.2 }
    let(:strict) { false }

    it { is_expected.to eql 1 }
  end

  context 'with letters not strict' do
    let(:value) { '1abc' }
    let(:strict) { false }

    it { is_expected.to eql 1 }
  end
end
