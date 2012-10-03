# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table do

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

end
