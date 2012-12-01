# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Border::ASCII, '#rendering' do

  subject { described_class.new row }

  context 'with empty row' do
    let(:row) { [] }

    it 'draws top line' do
      subject.top_line.should == "++"
    end

    it 'draws middle line' do
      subject.separator.should == "++"
    end

    it 'draw bottom line' do
      subject.bottom_line.should == "++"
    end

    it 'draws row line' do
      subject.row_line.should == "||"
    end
  end

  context 'with row' do
    let(:row) { ['a1', 'a2', 'a3'] }

    it 'draws top line' do
      subject.top_line.should == "+--+--+--+"
    end

    it 'draw middle line' do
      subject.separator.should == "+--+--+--+"
    end

    it 'draw bottom line' do
      subject.bottom_line.should == "+--+--+--+"
    end

    it 'draws row line' do
      subject.row_line.should == "|a1|a2|a3|"
    end
  end

end
