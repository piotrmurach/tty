# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Row, '#new' do
  let(:object) { described_class }

  subject { object.new data }

  context 'with no arguments' do
    let(:data) { [] }

    it { should be_instance_of(object) }

    it { should be_empty }
  end

  context 'with Array argument' do
    let(:data) { ['a'] }

    it { should be_instance_of(object) }

    its(:attributes) { should == [0] }

    its(:to_hash) { should == {0 => "a"} }
  end

  context 'with Hash argument' do
    let(:data) { {:id => 'a'} }

    it { should be_instance_of(object) }

    its(:attributes) { should == [:id] }

    its(:to_hash) { should == {:id => 'a'} }
  end
end
