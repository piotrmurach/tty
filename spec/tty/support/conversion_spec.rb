# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Conversion do
  let(:described_class) { Class.new { include TTY::Conversion } }
  let(:object) { described_class.new }
  let(:enumerable) { [] }

  subject { object.convert_to_array(enumerable) }

  context 'Array type' do
    it { should == enumerable }
  end

  context 'Hash type' do
    let(:enumerable) { {:a => 1, :b => 2} }

    it { should include([:a, 1]) }

    it { should include([:b, 2]) }
  end

  context 'responds to #to_ary' do
    let(:converted) { [] }
    let(:enumerable) { double('Enumerable', :to_ary => converted) }

    it { should == converted }
  end

  context 'does not respond to #to_ary' do
    let(:enumerable) { double('Enumerable') }

    it 'raises error' do
      expect { subject }.to raise_error(TTY::TypeError)
    end
  end
end
