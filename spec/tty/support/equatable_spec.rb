# encoding: utf-8

require 'spec_helper'

describe TTY::Equatable do
  let(:name) { 'Value' }

  context 'without attributes' do
    let(:klass) { ::Class.new }

    subject { klass.new }

    before {
      allow(klass).to receive(:name).and_return('Value')
      klass.send :include, described_class
    }

    it { is_expected.to respond_to :compare? }

    it { is_expected.to be_instance_of klass }

    describe '#eql?' do
      context 'when objects are similar' do
        let(:other) { subject.dup }

        it { expect(subject.eql?(other)).to eq(true) }
      end

      context 'when objects are different' do
        let(:other) { double('other') }

        it { expect(subject.eql?(other)).to eq(false) }
      end
    end

    describe '#==' do
      context 'when objects are similar' do
        let(:other) { subject.dup }

        it { expect(subject == other).to eq(true) }
      end

      context 'when objects are different' do
        let(:other) { double('other') }

        it { expect(subject == other).to eq(false) }
      end
    end

    describe '#inspect' do
      it { expect(subject.inspect).to eql('#<Value>') }
    end

    describe '#hash' do
      it { expect(subject.hash).to eql([klass].hash) }
    end
  end

  context 'with attributes' do
    let(:value) { 11 }
    let(:klass) {
      ::Class.new do
        include TTY::Equatable

        attr_reader :value

        def initialize(value)
          @value = value
        end
      end
    }

    before {
      allow(klass).to receive(:name).and_return name
    }

    subject { klass.new(value) }

    it 'dynamically defines #hash method' do
      expect(klass.method_defined?(:hash)).to eq(true)
    end

    it 'dynamically defines #inspect method' do
      expect(klass.method_defined?(:inspect)).to eq(true)
    end

    it { is_expected.to respond_to :compare? }

    it { is_expected.to respond_to :eql? }

    describe '#eql?' do
      context 'when objects are similar' do
        let(:other) { subject.dup }

        it { expect(subject.eql?(other)).to eq(true) }
      end

      context 'when objects are different' do
        let(:other) { double('other') }

        it { expect(subject.eql?(other)).to eq(false) }
      end
    end

    describe '#==' do
      context 'when objects are similar' do
        let(:other) { subject.dup }

        it { expect(subject == other).to eq(true) }
      end

      context 'when objects are different' do
        let(:other) { double('other') }

        it { expect(subject == other).to eq(false) }
      end
    end

    describe '#inspect' do
      it { expect(subject.inspect).to eql('#<Value value=11>') }
    end

    describe '#hash' do
      it { expect(subject.hash).to eql( ([klass] + [value]).hash) }
    end

    context 'equivalence relation' do
      let(:other) { subject.dup }

      it 'is not equal to nil reference' do
        expect(subject.eql?(nil)).to eq(false)
      end

      it 'is reflexive' do
        expect(subject.eql?(subject)).to eq(true)
      end

      it 'is symmetric' do
        expect(subject.eql?(other)).to eql( other.eql?(subject) )
      end
    end
  end

  context 'subclass' do
    let(:value) { 11 }
    let(:klass) {
      ::Class.new do
        include TTY::Equatable

        attr_reader :value

        def initialize(value)
          @value = value
        end
      end
    }
    let(:subclass) { ::Class.new(klass) }

    before {
      allow(klass).to receive(:name).and_return name
    }

    subject { subclass.new(value) }

    it { expect(subclass.superclass).to eq(klass) }

    it { is_expected.to respond_to :value }

    describe '#inspect' do
      it { expect(subject.inspect).to eql('#<Value value=11>') }
    end

    describe '#eql?' do
      context 'when objects are similar' do
        let(:other) { subject.dup }

        it { expect(subject.eql?(other)).to eq(true) }
      end

      context 'when objects are different' do
        let(:other) { double('other') }

        it { expect(subject.eql?(other)).to eq(false) }
      end
    end

    describe '#==' do
      context 'when objects are similar' do
        let(:other) { subject.dup }

        it { expect(subject == other).to eq(true) }
      end

      context 'when objects are different' do
        let(:other) { double('other') }

        it { expect(subject == other).to eq(false) }
      end
    end
  end
end
