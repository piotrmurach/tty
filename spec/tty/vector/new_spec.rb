# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Vector, '#new' do
  let(:object) { described_class }

  subject { object.new(argument) }

  context 'with no arguments' do
    subject { object.new }

    it 'sets elements to empty array' do
      subject.to_a.should == []
    end
  end

  context 'with nil argument' do
    let(:argument) { nil }

    it 'throws type error' do
      expect { subject }.to raise_error(TTY::TypeError)
    end
  end

  context 'with an argument that is a hash' do
    let(:argument) { {:value => 'Piotr'} }

    it 'sets elements' do
      subject.to_a.should == [[:value, 'Piotr']]
    end
  end

  context 'with an argument that respond to #to_ary' do
    let(:argument) {
      Class.new do
        def to_ary
          ['Piotr']
        end
      end.new
    }

    it 'sets elements' do
      subject.to_a.should == ['Piotr']
    end
  end
end
