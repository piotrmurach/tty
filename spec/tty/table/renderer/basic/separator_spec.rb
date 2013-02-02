# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, 'with separator' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }

  subject(:table) { described_class.new header, rows, :renderer => renderer }

  context 'when default' do
    let(:renderer) { :basic }

    it "sets through hash" do
      table.border :separator => :each_row
      expect(table.border.separator).to eql(:each_row)
    end

    it "sets through attribute" do
      table.border.separator= :each_row
      expect(table.border.separator).to eql(:each_row)
    end

    it "renders each row" do
      table.border.separator= :each_row
      table.to_s.should == <<-EOS.normalize
        h1 h2 h3

        a1 a2 a3

        b1 b2 b3
      EOS
    end
  end

  context 'when ascii' do
    let(:renderer) { :ascii }

    it "renders each row" do
      table.border.separator= :each_row
      table.to_s.should == <<-EOS.normalize
        +--+--+--+
        |h1|h2|h3|
        +--+--+--+
        |a1|a2|a3|
        +--+--+--+
        |b1|b2|b3|
        +--+--+--+
      EOS
    end
  end

  context 'when unicode' do
    let(:renderer) { :unicode }

    it "renders each row" do
      table.border.separator= :each_row
      table.to_s.should == <<-EOS.normalize
        ┌──┬──┬──┐
        │h1│h2│h3│
        ├──┼──┼──┤
        │a1│a2│a3│
        ├──┼──┼──┤
        │b1│b2│b3│
        └──┴──┴──┘
      EOS
    end
  end

end
