# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#eql?' do
  let(:rows)   { [['a1', 'a2'], ['b1', 'b2']] }
  let(:object) { described_class.new rows }

  subject { object.eql?(other) }

  describe '#inspect' do
    it { object.inspect.should =~ /#<TTY::Table/ }
  end

  context 'with the same object' do
    let(:other) { object }

    it { should be_true }

    it 'is symmetric' do
      should eql(other.eql?(object))
    end
  end

  context 'with an equivalent object' do
    let(:other) { object.dup }

    it { should be_true }

    it 'is symmetric' do
      should eql(other.eql?(object))
    end
  end
end
