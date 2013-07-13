# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#each' do
  let(:object) { described_class.new header, rows }
  let(:header) { ['Header1'] }
  let(:rows)   { [['a1'], ['b1']] }
  let(:field)  { TTY::Table::Field }

  context 'with no block' do
    subject { object.each }

    it { should be_instance_of(to_enum.class) }

    it 'yields the expected values' do
      subject.to_a.should eql(object.to_a)
    end
  end

  context 'with block' do
    let(:yields) { [] }

    subject { object.each { |row| yields << row } }

    it 'yields header and rows' do
      subject
      expect(yields.first).to be_instance_of(TTY::Table::Header)
      expect(yields.last).to be_instance_of(TTY::Table::Row)
    end

    it 'yields header and rows with expected attributes' do
      subject
      expect(yields).to eql(object.data)
    end

    it 'yields each row' do
      expect { subject }.to change { yields }.
        from( [] ).
        to( object.data )
    end
  end
end
