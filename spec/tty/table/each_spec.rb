# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#each' do
  let(:object) { described_class.new header, rows }
  let(:header) { ['Header1', 'Header2'] }
  let(:rows) { [['a1', 'a2'], ['b1', 'b2']] }

  context 'with no block' do
    subject { object.each }

    it { should be_instance_of(to_enum.class) }

    it 'yields the expected values' do
      subject.to_a.should eql(object.to_a)
    end
  end

  context 'with block' do
    subject { object.each { |row| yields << row } }
    let(:yields) { [] }

    it 'yields each row' do
      expect { subject }.to change { yields }.
        from( [] ).
        to( rows )
    end
  end
end
