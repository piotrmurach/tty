# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic, 'alignment' do
  let(:header)  { ['h1', 'h2', 'h3'] }
  let(:rows)    { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:options) { { column_aligns: column_aligns } }
  let(:table)   { TTY::Table.new(header, rows) }

  subject(:renderer) { described_class.new table, options }

  context 'with default' do
    let(:header)        { ['h1', 'h2'] }
    let(:rows)          { [['aaaaa', 'a'], ['b', 'bbbbb']] }
    let(:column_aligns) { nil }

    it 'aligns left by default' do
      expect(renderer.render).to eql <<-EOS.normalize
        h1    h2   
        aaaaa a    
        b     bbbbb
      EOS
    end
  end

  context 'with different headers' do
    let(:header)        { ['header1', 'head2', 'h3'] }
    let(:column_aligns) { [:left, :center, :right] }

    it 'aligns headers' do
      expect(renderer.render).to eql <<-EOS.normalize
        header1 head2 h3
        a1       a2   a3
        b1       b2   b3
      EOS
    end
  end

  context 'with different aligns' do
    let(:header)         { nil }
    let(:rows)           { [['aaaaa', 'a'], ['b', 'bbbbb']] }
    let(:column_aligns)  { [:left, :right] }

    it 'aligns table rows' do
      expect(renderer.render.to_s).to eql <<-EOS.normalize
        aaaaa     a
        b     bbbbb
      EOS
    end
  end

  context 'with individual field aligns' do
    let(:header)        { ['header1', 'header2', 'header3'] }
    let(:column_aligns) { [:left, :center, :right] }
    let(:options)       { {column_aligns: column_aligns} }
    let(:table) {
      TTY::Table.new header: header do |t|
        t << ['a1', 'a2', 'a3']
        t << ['b1', {:value => 'b2', :align => :right}, 'b3']
        t << ['c1', 'c2', {:value => 'c3', :align => :center}]
      end
    }

    it "takes individual fields over global aligns" do
      renderer.render.should == <<-EOS.normalize
        header1 header2 header3
        a1        a2         a3
        b1           b2      b3
        c1        c2      c3   
      EOS
    end
  end

  context 'with aligned header' do
    let(:rows)    { [['aaaaa1', 'a2', 'aaa3'], ['b1', 'bbbb2', 'bb3']] }
    let(:header)  {['h1', {:value => 'h2', :align => :right}, {:value => 'h3', :align => :center}] }
    let(:options) { { renderer: :basic } }

    it "aligns headres" do
      renderer.render.should == <<-EOS.normalize
        h1        h2  h3 
        aaaaa1 a2    aaa3
        b1     bbbb2 bb3 
      EOS
    end
  end
end
