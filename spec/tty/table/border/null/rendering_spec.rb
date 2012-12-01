# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Border::Null, '#rendering' do

  subject { described_class.new row }

  context 'with empty row' do
    let(:row) { [] }

    it 'draws top line' do
      subject.top_line.should be_nil
    end

    it 'draws middle line' do
      subject.separator.should be_nil
    end

    it 'draw bottom line' do
      subject.bottom_line.should be_nil
    end

    it 'draws row line' do
      subject.row_line.should == ''
    end
  end

  context 'with row' do
    let(:row) { ['a1', 'a2', 'a3'] }

    it 'draws top line' do
      subject.top_line.should be_nil
    end

    it 'draw middle line' do
      subject.separator.should be_nil
    end

    it 'draw bottom line' do
      subject.bottom_line.should be_nil
    end

    it 'draws row line' do
      subject.row_line.should == 'a1a2a3'
    end
  end

end
