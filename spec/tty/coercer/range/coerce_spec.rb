require 'spec_helper'

describe TTY::Coercer::Range, '#coerce' do

  subject { described_class.coerce(value) }

  context 'with empty' do
    let(:value) { '' }

    it { expect { subject }.to raise_error(TTY::InvalidArgument) }
  end

  context 'with 1' do
    let(:value) { '1' }

    it { should == (1..1) }
  end

  context 'with 1..10' do
    let(:value) { '1..10' }

    it { should == (1..10) }
  end

  context 'with 1-10' do
    let(:value) { '1-10' }

    it { should == (1..10) }
  end

  context 'with 1,10' do
    let(:value) { '1,10' }

    it { should == (1..10) }
  end

  context 'with 1...10' do
    let(:value) { '1...10'}

    it { should == (1...10) }
  end

  context 'with -1..10' do
    let(:value) { '-1..10' }

    it { should == (-1..10) }
  end

  context 'with 1..-10' do
    let(:value) { '1..-10' }

    it { should == (1..-10) }
  end
end # coerce
