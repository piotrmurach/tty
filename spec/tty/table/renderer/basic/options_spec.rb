# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic, 'options' do
  let(:rows)   { [['a1', 'a2'], ['b1', 'b2']] }
  let(:object) { described_class }
  let(:table) { TTY::Table.new(rows) }
  let(:widths) { nil }
  let(:aligns) { [] }
  let(:options) {
    {
      :column_widths => widths,
      :column_aligns  => aligns,
      :renderer => :basic
    }
  }

  subject { object.new table, options }

  its(:column_widths) { should be_empty }

  its(:column_aligns) { should eql(aligns) }

  it { subject.column_aligns.to_a.should be_empty }

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
      subject.column_aligns.to_a.should == aligns
    end
  end
end
