# encoding: utf-8

require 'spec_helper'

describe TTY::Table, '#initialize' do
  let(:header) { ['Header1', 'Header2'] }
  let(:rows)   { [['a1', 'a2'], ['b1', 'b2']] }

  it { is_expected.to be_kind_of(Enumerable) }

  it { is_expected.to be_kind_of(Comparable) }

  it { expect(Enumerable === subject).to eq(true) }

  context 'with rows only' do
    it 'initializes with rows as arguments' do
      table = TTY::Table[*rows]
      expect(table.to_a).to eql(rows)
    end

    it 'initializes with rows' do
      table = TTY::Table.new rows
      expect(table.to_a).to eql(rows)
    end

    it 'initializes table rows as an option' do
      table = TTY::Table.new rows: rows
      expect(table.to_a).to eq(rows)
    end

    it 'initializes table rows in a block with param' do
      table = TTY::Table.new do |t|
        t << rows[0]
        t << rows[1]
      end
      expect(table.to_a).to eq(rows)
    end

    it 'initializes table and adds rows' do
      table = TTY::Table.new
      table << rows[0]
      table << rows[1]
      expect(table.to_a).to eq(rows)
    end

    it 'chains rows' do
      table = TTY::Table.new
      table << rows[0] << rows[1]
      expect(table.to_a).to eq(rows)
    end

    context 'with data as hash' do
      let(:data) { [ {'Header1' => ['a1','a2'], 'Header2' => ['b1', 'b2'] }] }

      it 'extracts rows' do
        table = TTY::Table.new data
        expect(table.to_a).to include rows[0]
        expect(table.to_a).to include rows[1]
      end

      it 'extracts header' do
        table = TTY::Table.new data
        expect(table.header).to include header[0]
        expect(table.header).to include header[1]
      end
    end
  end

  context 'with header and rows' do
    it 'initializes header as an option' do
      table = TTY::Table.new header: header
      expect(table.header).to eql(header)
    end

    it 'initializes table rows as an argument' do
      table = TTY::Table.new header, rows
      expect(table.header).to eql(header)
      expect(table.rows).to eql(rows)
    end
  end

  context 'coercion' do
    it 'converts row arguments from hash to array' do
      table = TTY::Table.new rows: {a: 1, b: 2}
      expect(table.to_a).to include [:a, 1 ]
    end
  end
end
