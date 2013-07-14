# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::ColumnSet, '#extract_widths!' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }

  let(:table) { stub(:table, data: [header] + rows).as_null_object }

  subject { described_class.new table }

  it 'extract widths' do
    expect(subject.total_width).to eql(6)
  end
end
