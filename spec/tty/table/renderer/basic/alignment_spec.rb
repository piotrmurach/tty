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

  context 'with individual field aligns' do
    let(:header) { ['header1', 'header2', 'header3'] }
    let(:column_aligns) { [:left, :center, :right] }

    it "takes individual fields over global aligns" do
      options = {:header => header, :column_aligns => column_aligns, :renderer => :basic}
      table = described_class.new options do |t|
        t << ['a1', 'a2', 'a3']
        t << ['b1', {:value => 'b2', :align => :right}, 'b3']
        t << ['c1', 'c2', {:value => 'c3', :align => :center}]
      end
      table.to_s.should == <<-EOS.normalize
        header1 header2 header3
        a1        a2         a3
        b1           b2      b3
        c1        c2      c3   
      EOS
    end
  end

  context 'with aligned header' do
    let(:rows) { [['aaaaa1', 'a2', 'aaa3'], ['b1', 'bbbb2', 'bb3']] }

    it "aligns headres" do
      header = ['h1', {:value => 'h2', :align => :right}, {:value => 'h3', :align => :center}]
      options = {:header => header, :renderer => :basic, :rows => rows }
      table = described_class.new options
      table.to_s.should == <<-EOS.normalize
        h1        h2  h3 
        aaaaa1 a2    aaa3
        b1     bbbb2 bb3 
      EOS
    end

  end
end
