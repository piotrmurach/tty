# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::ASCII, 'with separator' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows)   { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:table)  { TTY::Table.new(header, rows) }

  let(:object) { described_class.new table }

  subject(:renderer) { object }

  context 'when ascii' do
    it "renders each row" do
      renderer.border.separator= :each_row
      renderer.render.should == <<-EOS.normalize
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
end
