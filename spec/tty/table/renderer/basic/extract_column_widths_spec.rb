# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic, '#extract_column_widths' do
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }

  subject { described_class.new }

  it 'calculates column widths' do
    rows = [['a1a', 'a2a2a2'], ['b1b1b', 'b2b2']]
    table = TTY::Table.new rows, :renderer => :basic
    subject.render(table)
    table.column_widths.should == [5,6]
  end

  it 'calcualtes column widths with header' do
    header = ['header1', 'head2', 'h3']
    table = TTY::Table.new header, rows
    subject.render(table)
    table.column_widths.should == [7,5,2]
  end
end
