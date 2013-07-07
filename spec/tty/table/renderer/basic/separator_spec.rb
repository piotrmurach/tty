# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic, 'with separator' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows)   { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:table)  { TTY::Table.new(header, rows) }

  let(:object) { described_class.new table }

  subject { object }

  context 'when default' do
    it "sets through hash" do
      table.border :separator => :each_row
      expect(table.border.separator).to eql(:each_row)
    end

    it "sets through attribute" do
      table.border.separator= :each_row
      expect(table.border.separator).to eql(:each_row)
    end

    it "sets through block" do
      table.border do
        separator :each_row
      end
      expect(table.border.separator).to eql(:each_row)
    end

    it "renders each row" do
      table.border.separator= :each_row
      subject.render.should == <<-EOS.normalize
        h1 h2 h3

        a1 a2 a3

        b1 b2 b3
      EOS
    end
  end
end
