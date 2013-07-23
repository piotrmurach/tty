# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, 'options' do
  let(:rows)   { [['a1', 'a2'], ['b1', 'b2']] }
  let(:widths) { nil }
  let(:aligns) { [] }
  let(:object) { described_class }
  let(:options) {
    {
      :column_widths => widths,
      :column_aligns  => aligns,
      :renderer => :basic
    }
  }

  subject { object.new rows, options }

  its(:header) { should be_nil }

  its(:rows) { should == rows }

  its(:orientation) { should be_kind_of TTY::Table::Orientation::Horizontal }
end
