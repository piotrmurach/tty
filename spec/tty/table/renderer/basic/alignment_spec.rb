# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, 'alignment' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows)   { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:options) { { :renderer => :basic, :column_aligns => column_aligns }}

  subject(:table) { described_class.new header, rows, options }

  context 'with default' do
    let(:header) { ['h1', 'h2'] }
    let(:rows) { [['aaaaa', 'a'], ['b', 'bbbbb']] }
    let(:column_aligns) { nil }

    it 'aligns left by default' do
      table.to_s.should == <<-EOS.normalize
        h1    h2   
        aaaaa a    
        b     bbbbb
      EOS
    end
  end

  context 'with different headers' do
    let(:header) { ['header1', 'head2', 'h3'] }
    let(:column_aligns) { [:left, :center, :right] }

    it 'aligns headers' do
      table.to_s.should == <<-EOS.normalize
        header1 head2 h3
        a1       a2   a3
        b1       b2   b3
      EOS
    end
  end

  context 'with different aligns' do
    let(:header) { nil }
    let(:rows) { [['aaaaa', 'a'], ['b', 'bbbbb']] }
    let(:column_aligns)  { [:left, :right] }

    it 'aligns table rows' do
      table.to_s.should == <<-EOS.normalize
        aaaaa     a
        b     bbbbb
      EOS
    end
  end

  it 'aligns table rows' do
    rows = [['aaaaa', 'a'], ['b', 'bbbbb']]
    table = TTY::Table.new rows, :renderer => :basic,
                                  :column_aligns => [:left, :right]
    table.to_s.should == <<-EOS.normalize
      aaaaa     a
      b     bbbbb
    EOS
  end
end
