# encoding: utf-8

require 'spec_helper'

describe TTY::Table, '#each' do
  let(:table) { described_class.new header, rows }
  let(:header) { ['Header1'] }
  let(:rows)   { [['a1'], ['b1']] }
  let(:field)  { TTY::Table::Field }

  context 'with no block' do
    subject { table.each }

    it { is_expected.to be_instance_of(to_enum.class) }

    it 'yields the expected values' do
      expect(subject.to_a).to eql(table.to_a)
    end
  end

  context 'with block' do
    let(:yields) { [] }

    subject { table.each { |row| yields << row } }

    it 'yields header and rows' do
      subject
      expect(yields.first).to be_instance_of(TTY::Table::Header)
      expect(yields.last).to be_instance_of(TTY::Table::Row)
    end

    it 'yields header and rows with expected attributes' do
      subject
      expect(yields).to eql(table.data)
    end

    xit 'yields each row' do
      expect { subject }.to change { yields }.from([]).to(table.data)
    end
  end
end
