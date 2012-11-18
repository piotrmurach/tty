# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic, '#render' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }

  it 'displays table without styling' do
    table = TTY::Table.new :renderer => :basic
    table << rows[0] << rows[1]
    table.to_s.should == <<-EOS.normalize
      a1 a2 a3
      b1 b2 b3
    EOS
  end

  it 'displays table with header' do
    table = TTY::Table.new :header => header, :renderer => :basic
    table << rows[0] << rows[1]
    table.to_s.should == <<-EOS.normalize
      h1 h2 h3
      a1 a2 a3
      b1 b2 b3
    EOS
  end

  it 'displays table according to widths' do
    header = ['h1', 'h2']
    rows = [['aaa1', 'a2'], ['b1', 'bb1']]
    table = TTY::Table.new header, rows, :renderer => :basic
    table.to_s.should == <<-EOS.normalize
      h1   h2 
      aaa1 a2 
      b1   bb1
    EOS
  end

  it 'header greater than row sizes' do
    header = ['header1', 'header2', 'header3']
    table = TTY::Table.new header, rows, :renderer => :basic
    table.to_s.should == <<-EOS.normalize
      header1 header2 header3
      a1      a2      a3     
      b1      b2      b3     
    EOS
  end
end
