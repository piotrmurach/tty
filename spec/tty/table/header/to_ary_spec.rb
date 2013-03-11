# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Header, '#to_ary' do
  let(:object) { described_class.new(attributes) }
  let(:attributes) { [:id, :name, :age] }

  subject { object.to_ary }

  it { should be_instance_of(Array) }

  it { should == attributes }
end
