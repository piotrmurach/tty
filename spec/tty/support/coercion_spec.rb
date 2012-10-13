# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Coercion do
  let(:described_class) { Class.new { include TTY::Coercion } }
  let(:object) { described_class.new }
  let(:value) { [] }
  let(:coercible) { [ value, Array, :to_a] }

  subject { object.coerce_to( *coercible ) }

  it { should == value }

  context 'coerces into integer' do
    let(:value) { '123' }
    let(:coercible) { [ value, Integer, :to_i] }

    it { should be_kind_of(Integer) }

    it { should == value.to_i }
  end

  context 'coerces into symbol' do
    let(:value) { 'argument' }
    let(:coercible) { [value, Symbol, :to_sym]}

    it { should be_kind_of(Symbol) }

    it { should == value.to_sym }
  end

  context 'coerces into string' do
    let(:value) { true }
    let(:coercible) { [value, String, :to_s] }

    it { should be_kind_of(String) }

    it { should == value.to_s }
  end
end
