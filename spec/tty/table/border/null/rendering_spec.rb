# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Border::Null, '#rendering' do
  let(:border) { nil }

  subject { described_class.new row, :border => border }

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
      subject.row_line.should == 'a1 a2 a3'
    end
  end

  context 'with border' do
    let(:row) { ['a1', 'a2', 'a3'] }
    let(:border) { {
      'top'          => '=',
      'top_mid'      => '=',
      'top_left'     => '=',
      'top_right'    => '=',
      'bottom'       => '=',
      'bottom_mid'   => '=',
      'bottom_left'  => '=',
      'bottom_right' => '=',
      'mid'          => '=',
      'mid_mid'      => '=',
      'mid_left'     => '=',
      'mid_right'    => '=',
      'left'         => '=',
      'right'        => '='
    } }

    it 'draws top line' do
      expect(subject.top_line).to eql '=========='
    end

    it 'draws separator line' do
      expect(subject.separator).to eql '=========='
    end

    it 'draws bottom line' do
      expect(subject.bottom_line).to eql '=========='
    end

    it 'draws row line' do
      expect(subject.row_line).to eql '=a1=a2=a3='
    end
  end

end
