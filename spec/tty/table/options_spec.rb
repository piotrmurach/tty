# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, 'options' do
  let(:rows)   { [['a1', 'a2'], ['b1', 'b2']] }
  let(:widths) { [] }
  let(:aligns) { [] }
  let(:object) {
    described_class.new rows, :column_widths => widths, :column_aligns  => aligns
  }

  subject { object.to_s; object.renderer }

  its(:column_widths) { should == [2,2] }

  its(:column_aligns) { should == [] }

  context '#column_widths' do
    let(:widths) { [10, 10] }

    its(:column_widths) { should == widths }
  end

  context '#column_aligns' do
    let(:aligns) { [:center, :center] }

    its(:column_aligns) { should == aligns }
  end
end
