# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Field, '#new' do
  let(:object) { described_class }

  subject { object.new value }

  context 'with only value' do
    let(:value) { 'foo' }

    it { should be_instance_of(object) }

    its(:value) { should == value }

    its(:height) { should == 1 }
  end

  context 'with hash value' do
    let(:value) { { :value => 'foo' } }

    it { should be_instance_of(object) }

    its(:value) { should == 'foo' }

    its(:height) { should == 1 }
  end
end
