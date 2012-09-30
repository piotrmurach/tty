# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table do

  it { should be_kind_of(Enumerable) }
  it { should be_kind_of(Comparable) }

  it { (Enumerable === subject).should be_true }

  context '#initalize' do
    let(:header) { ['Header1', 'Header2'] }
    let(:rows) { [['a1', 'a2'], ['b1', 'b2']] }

    it 'initializes table header' do
      table = TTY::Table.new header
      table.header.should == header
    end

    it 'initializes table header as an option' do
      table = TTY::Table.new :header => header
      table.header.should == header
    end

    it 'initializes table rows as an option' do
      table = TTY::Table.new :header => header, :rows => rows
      table.to_a.should == rows
    end

    it 'initializes table rows as an argument' do
      table = TTY::Table.new header, rows
      table.to_a.should == rows
    end

    it 'initializes table rows in a block with param' do
      table = TTY::Table.new header do |t|
        t << rows[0]
        t << rows[1]
      end
      table.to_a.should == rows
    end

    it 'initializes table and adds rows' do
      table = TTY::Table.new header
      table << rows[0]
      table << rows[1]
      table.to_a.should == rows
    end
  end

  context '#size' do
    it 'has no size' do
      table = TTY::Table.new
      table.size.should == 0
    end

    it 'has size' do
      rows = [['a1', 'a2', 'a3'], ['b1', 'b2', 'c3']]
      table = TTY::Table.new ['Header1', 'Header2'], rows
      table.size.should == 3
    end
  end

  context '#columns' do
    it 'looks up column' do
      rows = [['a1', 'a2'], ['b1', 'b2']]
      table = TTY::Table.new
      table << rows[0]
      table << rows[1]
      table[0].should == ['a1', 'b1']
    end
  end

end # TTY::Table
