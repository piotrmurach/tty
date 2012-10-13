# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Operation::AlignmentSet, '#each' do
  let(:alignments) { [:left, :center, :right] }
  let(:yields) { [] }
  let(:object) { described_class.new alignments }

  subject { object.each { |alignment| yields << alignment } }

  it 'yields each alignment' do
    expect { subject }.to change { yields.dup }.
      from([]).
      to(alignments)
  end
end
