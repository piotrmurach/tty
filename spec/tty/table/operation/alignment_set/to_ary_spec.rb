# encoding: utf-8

require 'spec_helper'

describe TTY::Table::Operation::AlignmentSet, '#to_ary' do
  let(:argument) { [:center, :left] }
  let(:object)   { described_class.new argument }

  subject { object.to_ary }

  it { is_expected.to be_instance_of(Array) }

  it { is_expected.to eq(argument) }
end
