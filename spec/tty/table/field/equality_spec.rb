# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Field, '#==' do
  let(:value) { '1' }
  let(:object) { described_class.new(value) }

  subject { object == other }

  context 'with the same object' do
    let(:other) { object }

    it { should be_true }

    it 'is symmetric' do
      should eql(other == object)
    end
  end

  context 'with an equivalent object' do
    let(:other) { object.dup }

    it { should be_true }

    it 'is symmetric' do
      should eql(other == object)
    end
  end

  context 'with an equivalent object of subclass' do
    let(:other) { Class.new(described_class).new(value) }

    it { should be_false }

    it 'is symmetric' do
      should_not eql(other == object)
    end
  end

  context 'with an object having a different value' do
    let(:other_value) { '2' }
    let(:other) { described_class.new(other_value) }

    it { should be_false }

    it 'is symmetric' do
      should eql(other == object)
    end
  end
end
