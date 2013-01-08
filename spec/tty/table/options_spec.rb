# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, 'options' do
  let(:rows)   { [['a1', 'a2'], ['b1', 'b2']] }
  let(:widths) { nil }
  let(:aligns) { [] }
  let(:object) {
    described_class.new rows,
      :column_widths => widths,
      :column_aligns  => aligns,
      :renderer => :basic
  }

  subject { object.to_s; object.renderer }

  its(:column_widths) { should == [2,2] }

  its(:alignments) { should be_kind_of TTY::Table::Operation::AlignmentSet }

  it 'is empty' do
    subject.alignments.to_a.should be_empty
  end

  context '#column_widths' do
    let(:widths) { [10, 10] }

    its(:column_widths) { should == widths }
  end

  context '#column_widths empty' do
    let(:widths) { [] }

    it { expect { subject }.to raise_error(TTY::InvalidArgument) }
  end

  context '#column_aligns' do
    let(:aligns) { [:center, :center] }

    it 'unwraps original array' do
      subject.alignments.to_a.should == aligns
    end
  end
end
