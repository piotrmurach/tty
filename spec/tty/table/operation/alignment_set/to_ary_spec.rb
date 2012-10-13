# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Operation::AlignmentSet, '#to_ary' do
  let(:argument) { [:center, :left] }
  let(:object) { described_class.new argument }

  subject { object.to_ary }

  it { should be_instance_of(Array) }

  it { should == argument }
end
