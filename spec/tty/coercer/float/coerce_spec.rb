# encoding: utf-8

require 'spec_helper'

describe TTY::Coercer::Float, '#coerce' do
  let(:strict) { true }

  subject { described_class.coerce(value, strict) }

  context 'with empty' do
    let(:value) { '' }

    it { expect { subject }.to raise_error(TTY::InvalidArgument) }
  end

  context 'with 1 as string' do
    let(:value) { '1' }

    it { is_expected.to eql 1.0 }
  end

  context 'with float' do
    let(:value) { '1.2a' }

    it { expect { subject }.to raise_error(TTY::InvalidArgument) }
  end

  context 'with float not strict' do
    let(:value)  { '1.2abc'}
    let(:strict) { false }

    it { is_expected.to eql 1.2 }
  end
end
