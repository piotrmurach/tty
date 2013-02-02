# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#border' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }

  subject(:table) { described_class.new header, rows, :renderer => renderer }

  context 'when default' do
    let(:renderer) { :basic }

    it 'specifies border in block' do
      table.border do
        mid          '='
        mid_mid      ' '
      end

      table.to_s.should == <<-EOS.normalize
        h1 h2 h3 
        == == ==
        a1 a2 a3 
        b1 b2 b3 
      EOS
    end
  end

  context 'when ascii' do
    let(:renderer) { :ascii }

    it 'specifies border in block' do
      table.border do
        mid          '='
        mid_mid      '='
        mid_left     '='
        mid_right    '='
      end

      table.to_s.should == <<-EOS.normalize
        +--+--+--+
        |h1|h2|h3|
        ==========
        |a1|a2|a3|
        |b1|b2|b3|
        +--+--+--+
      EOS
    end

    it 'specifies border as hash' do
      table.border({ :characters => {
        'mid'       => '=',
        'mid_mid'   => '=',
        'mid_left'  => '=',
        'mid_right' => '=',
      }})

      table.to_s.should == <<-EOS.normalize
        +--+--+--+
        |h1|h2|h3|
        ==========
        |a1|a2|a3|
        |b1|b2|b3|
        +--+--+--+
      EOS
    end
  end

  context 'when unicode' do
    let(:renderer) { :unicode }

    it 'specifies border in block' do
      table.border do
        mid          '='
        mid_mid      '='
        mid_left     '='
        mid_right    '='
      end

      table.to_s.should == <<-EOS.normalize
        ┌──┬──┬──┐
        │h1│h2│h3│
        ==========
        │a1│a2│a3│
        │b1│b2│b3│
        └──┴──┴──┘
      EOS
    end
  end

end # border
