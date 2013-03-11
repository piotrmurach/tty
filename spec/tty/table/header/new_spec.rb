# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Header, '#new' do
  let(:object) { described_class }

  context 'with no arguments' do
    subject { object.new }

    it { should be_instance_of(object) }

    it { should be_empty }
  end

  context 'with attributes' do
    subject { object.new(attributes) }

    let(:attributes) { ['id', 'name', 'age'] }

    it { should be_instance_of(object) }

    it { should == attributes }
  end
end
