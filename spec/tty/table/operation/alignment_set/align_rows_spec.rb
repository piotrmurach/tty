# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Operation::AlignmentSet, '#align_rows' do
  let(:object)  { described_class.new alignments }
  let(:rows) { [['a1', 'a2'], ['b1', 'b2']] }

  subject { object.align_rows rows, :column_widths => widths }

  context 'aligned with column widths and no alignments' do
    let(:alignments) { [] }
    let(:widths) { [4, 4] }

    it { should be_instance_of(Array) }

    it { should == ['a1   a2  ', 'b1   b2  '] }
  end

  context 'aligned with column widths and alignments' do
    let(:alignments) { [:right, :left] }
    let(:widths) { [4, 4] }

    it { should be_instance_of(Array) }

    it { should == ['  a1 a2  ', '  b1 b2  '] }
  end

  context 'aligned with no column widths and no alignments' do
    let(:alignments) { [] }
    let(:widths) { [] }

    it { should be_instance_of(Array) }

    it { should == ['a1 a2', 'b1 b2'] }
  end

  context 'aligned with no column widths and alignments' do
    let(:alignments) { [:right, :left] }
    let(:widths) { [] }

    it { should be_instance_of(Array) }

    it { should == ['a1 a2', 'b1 b2'] }
  end
end
