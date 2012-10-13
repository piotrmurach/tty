# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Operation::Alignment, '#new' do
  let(:object) { described_class }

  subject { object.new(type) }

  context 'with no type' do
    let(:type) { nil }

    it { should be_instance_of(object) }

    its(:type) { should == :left }
  end

  context 'with unrecognized type' do
    let(:type) { :unknown }

    it 'raises exception' do
      expect { subject }.to raise_error(TTY::TypeError)
    end
  end

  context 'with coerced type' do
    let(:type) { 'center' }

    its(:type) { should == :center }
  end
end
