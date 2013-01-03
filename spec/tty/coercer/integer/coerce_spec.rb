require 'spec_helper'

describe TTY::Coercer::Integer, '#coerce' do
  let(:strict) { true }
  subject { described_class.coerce(value, strict) }

  context 'with empty' do
    let(:value) { '' }

    it { expect { subject }.to raise_error(TTY::InvalidArgument) }
  end

  context 'with 1 as string' do
    let(:value) { '1' }

    it { expect(subject).to eql 1 }
  end

  context 'with float' do
    let(:value) { 1.2 }

    it { expect { subject }.to raise_error(TTY::InvalidArgument) }
  end

  context 'with float not strict' do
    let(:value) { 1.2 }
    let(:strict) { false }

    it { expect(subject).to eql 1 }
  end

  context 'with letters not strict' do
    let(:value) { '1abc' }
    let(:strict) { false }

    it { expect(subject).to eql 1 }
  end

end
