# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::ColumnSet, '#extract_widths!' do

  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }

  let(:table) {
    stub(:table, :column_widths => column_widths,
     :header => header, :to_a => rows).as_null_object
  }

  subject { described_class.new table }

  context 'with column_widths' do
    let(:column_widths) { [5,5,5] }

    it '' do
      subject.extract_widths!
      subject.column_widths.should == column_widths
    end

  end
end
