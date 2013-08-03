# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Columns, '#enforce' do
  let(:header) { ['h1', 'h2', 'h3', 'h4'] }
  let(:rows)   { [['a1', 'a2', 'a3', 'a4'], ['b1', 'b2', 'b3', 'b4']] }
  let(:table)  { TTY::Table.new(header, rows) }
  let(:object) { described_class.new(renderer) }

  subject { object.enforce }

  context 'with width contraint' do
    let(:renderer) { TTY::Table::Renderer::Basic.new(table, options) }
    let(:options) { { width: 5 }}

    it 'raises error when table width is too small' do
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  context 'with table larger than allowed width' do
    let(:renderer) { TTY::Table::Renderer::Basic.new(table, options) }
    let(:options) { { width: 8 }}

    it 'changes table orientation to vertical' do
      TTY.shell.should_receive(:warn)
      expect(renderer.column_widths).to eql([2,2,2,2])
      expect(renderer.table.orientation.name).to eql(:horizontal)
      subject
      expect(renderer.column_widths).to eq([2,2,2])
      expect(renderer.table.orientation.name).to eql(:vertical)
    end
  end

  context 'with table less than allowed width' do
    let(:renderer) { TTY::Table::Renderer::Basic.new(table, options) }
    let(:options) { { width: 15 }}

    before { TTY.shell.stub(:warn) }

    it "doesnt change original widths" do
      expect(renderer.column_widths).to eq([2,2,2,2])
    end
  end
end
