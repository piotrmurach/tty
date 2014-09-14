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
      expect { subject }.to raise_error(TTY::ResizeError)
    end
  end

  context 'with width contraint matching natural width' do
    let(:renderer) { TTY::Table::Renderer::Basic.new(table, options) }
    let(:options) { { width: 11, resize: true }}

    it 'raises error when table width is too small' do
      expect(object).to receive(:expand)
      subject
    end
  end

  context 'with table larger than allowed width' do
    let(:renderer) { TTY::Table::Renderer::Basic.new(table, options) }

    context 'with resize' do
      let(:options) { { width: 8, resize: true } }

      it 'calls shrink' do
        expect(object).to receive(:shrink)
        subject
      end
    end

    context 'without resize' do
      let(:options) { { width: 8, resize: false }}

      it 'changes table orientation to vertical' do
        allow(TTY.shell).to receive(:warn)
        expect(renderer.column_widths).to eql([2,2,2,2])
        expect(renderer.table.orientation.name).to eql(:horizontal)
        subject
        expect(renderer.column_widths).to eq([2,2])
        expect(renderer.table.orientation.name).to eql(:vertical)
      end
    end
  end

  context 'with table less than allowed width' do
    let(:renderer) { TTY::Table::Renderer::Basic.new(table, options) }
    let(:options) { { width: 15 }}

    before { allow(TTY.shell).to receive(:warn) }

    it "doesn't change original widths" do
      expect(renderer.column_widths).to eq([2,2,2,2])
    end
  end
end
