# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Border::Unicode, '#rendering' do

  subject { described_class.new(column_widths) }

  context 'with empty row' do
    let(:row) { TTY::Table::Row.new([]) }
    let(:column_widths) { [] }

    it 'draws top line' do
      subject.top_line.should == "┌┐"
    end

    it 'draws middle line' do
      subject.separator.should == "├┤"
    end

    it 'draw bottom line' do
      subject.bottom_line.should == "└┘"
    end

    it 'draws row line' do
      subject.row_line(row).should == "││"
    end
  end

  context 'with row' do
    let(:row) { TTY::Table::Row.new(['a1', 'a2', 'a3']) }
    let(:column_widths) { [2,2,2] }

    it 'draws top line' do
      subject.top_line.should == "┌──┬──┬──┐"
    end

    it 'draw middle line' do
      subject.separator.should == "├──┼──┼──┤"
    end

    it 'draw bottom line' do
      subject.bottom_line.should == "└──┴──┴──┘"
    end

    it 'draws row line' do
      subject.row_line(row).should == "│a1│a2│a3│"
    end
  end

  context 'with multiline row' do
    let(:row) { TTY::Table::Row.new(["a1\nb1\nc1", 'a2', 'a3']) }
    let(:column_widths) { [2,2,2] }

    it 'draws row line' do
      subject.row_line(row).should == <<-EOS.normalize
        │a1│a2│a3│
        │b1│  │  │
        │c1│  │  │
      EOS
    end
  end
end
