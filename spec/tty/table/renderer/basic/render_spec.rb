# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic, '#render' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }

  subject { described_class.new }

  context 'without border' do

    it 'displays table without styling' do
      table = TTY::Table.new rows
      subject.render(table).should == <<-EOS.normalize
        a1 a2 a3
        b1 b2 b3
      EOS
    end

    it 'displays table with header' do
      table = TTY::Table.new header, rows
      subject.render(table).should == <<-EOS.normalize
        h1 h2 h3
        a1 a2 a3
        b1 b2 b3
      EOS
    end

    it 'displays table according to widths' do
      header = ['h1', 'h2']
      rows = [['aaa1', 'a2'], ['b1', 'bb1']]
      table = TTY::Table.new header, rows
      subject.render(table).should == <<-EOS.normalize
        h1   h2 
        aaa1 a2 
        b1   bb1
      EOS
    end

    it 'header greater than row sizes' do
      header = ['header1', 'header2', 'header3']
      table = TTY::Table.new header, rows
      subject.render(table).should == <<-EOS.normalize
        header1 header2 header3
        a1      a2      a3     
        b1      b2      b3     
      EOS
    end

  end

  context 'with ASCII border' do
    let(:border) { TTY::Table::Border::ASCII }

    it 'display table rows' do
      table = TTY::Table.new rows
      subject.render(table, border).should == <<-EOS.normalize
        +---+---+--+
        |a1 |a2 |a3|
        |b1 |b2 |b3|
        +---+---+--+
      EOS
    end

    it 'displays table with header' do
      table = TTY::Table.new header, rows
      subject.render(table, border).should == <<-EOS.normalize
        +---+---+--+
        |h1 |h2 |h3|
        +---+---+--+
        |a1 |a2 |a3|
        |b1 |b2 |b3|
        +---+---+--+
      EOS
    end

    it 'displays table according to widths' do
      header = ['h1', 'h2']
      rows = [['aaa1', 'a2'], ['b1', 'bb1']]
      table = TTY::Table.new header, rows
      subject.render(table, border).should == <<-EOS.normalize
       +-----+---+
       |h1   |h2 |
       +-----+---+
       |aaa1 |a2 |
       |b1   |bb1|
       +-----+---+
      EOS
    end

    it 'header greater than row sizes' do
      header = ['header1', 'header2', 'header3']
      table = TTY::Table.new header, rows
      subject.render(table, border).should == <<-EOS.normalize
       +--------+--------+-------+
       |header1 |header2 |header3|
       +--------+--------+-------+
       |a1      |a2      |a3     |
       |b1      |b2      |b3     |
       +--------+--------+-------+
      EOS
    end
  end

  context 'with Unicode border' do
    let(:border) { TTY::Table::Border::Unicode }

    it 'display table rows' do
      table = TTY::Table.new rows
      subject.render(table, border).should == <<-EOS.normalize
        ┌───┬───┬──┐
        │a1 │a2 │a3│
        │b1 │b2 │b3│
        └───┴───┴──┘
      EOS
    end

    it 'displays table with header' do
      table = TTY::Table.new header, rows
      subject.render(table, border).should == <<-EOS.normalize
        ┌───┬───┬──┐
        │h1 │h2 │h3│
        ├───┼───┼──┤
        │a1 │a2 │a3│
        │b1 │b2 │b3│
        └───┴───┴──┘
      EOS
    end

    it 'displays table according to widths' do
      header = ['h1', 'h2']
      rows = [['aaa1', 'a2'], ['b1', 'bb1']]
      table = TTY::Table.new header, rows
      subject.render(table, border).should == <<-EOS.normalize
        ┌─────┬───┐
        │h1   │h2 │
        ├─────┼───┤
        │aaa1 │a2 │
        │b1   │bb1│
        └─────┴───┘
      EOS
    end

    it 'header greater than row sizes' do
      header = ['header1', 'header2', 'header3']
      table = TTY::Table.new header, rows
      subject.render(table, border).to_s.should == <<-EOS.normalize
        ┌────────┬────────┬───────┐
        │header1 │header2 │header3│
        ├────────┼────────┼───────┤
        │a1      │a2      │a3     │
        │b1      │b2      │b3     │
        └────────┴────────┴───────┘
      EOS
    end
  end

end
