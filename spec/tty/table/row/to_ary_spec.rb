# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Row, '#to_ary' do
  let(:object) { described_class.new data }
  let(:data) { ['a', 'b'] }

  subject { object.to_ary }

  it { should be_instance_of(Array) }

  it { should == data }
end
