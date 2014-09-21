# encoding: utf-8

require 'spec_helper'

describe TTY::Table::Renderer::Basic, 'options' do
  let(:rows)   { [['a1', 'a2'], ['b1', 'b2']] }
  let(:object) { described_class }
  let(:table)  { TTY::Table.new(rows) }
  let(:widths) { nil }
  let(:aligns) { [] }
  let(:options) {
    {
      :column_widths => widths,
      :column_aligns  => aligns,
      :renderer => :basic
    }
  }

  subject(:renderer) { object.new table, options }

  it { expect(renderer.border).to be_kind_of(TTY::Table::BorderOptions) }

  it { expect(renderer.column_widths).to eql([2,2]) }

  it { expect(renderer.column_aligns).to eql(aligns) }

  it { expect(renderer.column_aligns.to_a).to be_empty }

  context '#column_widths' do
    let(:widths) { [10, 10] }

    it { expect(renderer.column_widths).to eq(widths) }
  end

  context '#column_widths empty' do
    let(:widths) { [] }

    it { expect { renderer.column_widths }.to raise_error(TTY::InvalidArgument) }
  end

  context '#column_aligns' do
    let(:aligns) { [:center, :center] }

    it 'unwraps original array' do
      expect(renderer.column_aligns.to_a).to eq(aligns)
    end
  end
end
