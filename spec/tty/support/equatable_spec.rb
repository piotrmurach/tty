# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Equatable do
  let(:name) { 'Value' }

  context 'without attributes' do
    let(:klass) { ::Class.new }

    subject { klass.new }

    before {
      klass.stub(:name).and_return 'Value'
      klass.send :include, described_class
    }

    it { should respond_to :compare? }

    it { should be_instance_of klass }

    describe '#eql?' do
      context 'when objects are similar' do
        let(:other) { subject.dup }

        it { subject.eql?(other).should be_true }
      end

      context 'when objects are different' do
        let(:other) { double('other') }

        it { subject.eql?(other).should be_false }
      end
    end

    describe '#==' do
      context 'when objects are similar' do
        let(:other) { subject.dup }

        it { (subject == other).should be_true }
      end

      context 'when objects are different' do
        let(:other) { double('other') }

        it { (subject == other)}
      end
    end

    describe '#inspect' do
      it { subject.inspect.should eql('#<Value>') }
    end

    describe '#hash' do
      it { subject.hash.should eql([klass].hash) }
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
      klass.stub(:name).and_return name
    }

    subject { klass.new(value) }

    it 'dynamically defines #hash method' do
      klass.method_defined?(:hash).should be_true
    end

    it 'dynamically defines #inspect method' do
      klass.method_defined?(:inspect).should be_true
    end

    it { should respond_to :compare? }

    it { should respond_to :eql? }

    describe '#eql?' do
      context 'when objects are similar' do
        let(:other) { subject.dup }

        it { subject.eql?(other).should be_true }
      end

      context 'when objects are different' do
        let(:other) { double('other') }

        it { subject.eql?(other).should be_false }
      end
    end

    describe '#==' do
      context 'when objects are similar' do
        let(:other) { subject.dup }

        it { (subject == other).should be_true }
      end

      context 'when objects are different' do
        let(:other) { double('other') }

        it { (subject == other).should be_false }
      end
    end

    describe '#inspect' do
      it { subject.inspect.should eql('#<Value value=11>') }
    end

    describe '#hash' do
      it { subject.hash.should eql( ([klass] + [value]).hash) }
    end

    context 'equivalence relation' do
      let(:other) { subject.dup }

      it 'is not equal to nil reference' do
         subject.eql?(nil).should be_false
      end

      it 'is reflexive' do
        subject.eql?(subject).should be_true
      end

      it 'is symmetric' do
        (subject.eql?(other)).should eql( other.eql?(subject) )
      end

      it 'is transitive'
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
      klass.stub(:name).and_return name
    }

    subject { subclass.new(value) }

    it { subclass.superclass.should == klass }

    it { should respond_to :value }

    describe '#inspect' do
      it { subject.inspect.should eql('#<Value value=11>') }
    end

    describe '#eql?' do
      context 'when objects are similar' do
        let(:other) { subject.dup }

        it { subject.eql?(other).should be_true }
      end

      context 'when objects are different' do
        let(:other) { double('other') }

        it { subject.eql?(other).should be_false }
      end
    end

    describe '#==' do
      context 'when objects are similar' do
        let(:other) { subject.dup }

        it { (subject == other).should be_true }
      end

      context 'when objects are different' do
        let(:other) { double('other') }

        it { (subject == other)}
      end
    end
  end
end
