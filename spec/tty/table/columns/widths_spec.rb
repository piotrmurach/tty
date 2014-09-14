# encoding: utf-8

require 'spec_helper'

describe TTY::Table::Columns, 'column widths' do
  let(:header) { ['h1', 'h2', 'h3', 'h4'] }
  let(:rows)   { [['a1', 'a2', 'a3', 'a4'], ['b1', 'b2', 'b3', 'b4']] }
  let(:table)  { TTY::Table.new(header, rows) }

  subject { described_class.new(renderer) }

  context 'with basic renderer' do
    let(:renderer) { TTY::Table::Renderer::Basic.new(table) }

    it 'calculates columns natural width' do
      expect(subject.natural_width).to eq(11)
    end

    it 'calculates miminimum columns width' do
      expect(subject.minimum_width).to eq(7)
    end
  end

  context 'with ascii renderer' do
    let(:renderer) { TTY::Table::Renderer::ASCII.new(table) }

    it 'calculates columns natural width' do
      expect(subject.natural_width).to eq(13)
    end

    it 'calculates miminimum columns width' do
      expect(subject.minimum_width).to eq(9)
    end
  end
end
