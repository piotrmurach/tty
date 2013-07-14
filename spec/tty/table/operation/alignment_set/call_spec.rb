# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Operation::AlignmentSet, '#call' do
  let(:object)  { described_class.new alignments, widths }
  let(:value) { 'a1' }
  let(:field) { TTY::Table::Field.new(value)}

  subject { object.call(field, 0, 0) }

  context 'aligned with column widths and no alignments' do
    let(:alignments) { [] }
    let(:widths) { [4, 4] }

    it { should == "#{value}  " }
  end

  context 'aligned with column widths and alignments' do
    let(:alignments) { [:right, :left] }
    let(:widths) { [4, 4] }

    it { should == "  #{value}" }
  end

  context 'aligned with no column widths and no alignments' do
    let(:alignments) { [] }
    let(:widths) { [] }

    it { should == "#{value}" }
  end

  context 'aligned with no column widths and alignments' do
    let(:alignments) { [:right, :left] }
    let(:widths) { [] }

    it { should == "#{value}" }
  end
end
