# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic, 'alignment' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }

  it 'aligns left by default' do
    header = ['h1', 'h2']
    rows = [['aaaaa', 'a'], ['b', 'bbbbb']]
    table = TTY::Table.new header, rows, :renderer => :basic
    table.to_s.should == <<-EOS.normalize
      h1    h2   
      aaaaa a    
      b     bbbbb
    EOS
  end

  it 'aligns table headers' do
    header = ['header1', 'head2', 'h3']
    table = TTY::Table.new header, rows, :render => :basic,
      :column_aligns => [:left, :center, :right]
    table.to_s.should == <<-EOS.normalize
      header1 head2 h3
      a1       a2   a3
      b1       b2   b3
    EOS
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
