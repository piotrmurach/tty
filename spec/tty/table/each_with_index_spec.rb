# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#each_with_index' do
  let(:object) { described_class.new header, rows }
  let(:header) { ['Header1', 'Header2'] }
  let(:rows) { [['a1', 'a2'], ['b1', 'b2']] }

  context 'with no block' do
    subject { object.each_with_index }
    it { should be_instance_of(to_enum.class) }

    it 'yields the expected values' do
      subject.to_a.should eql(object.to_a)
    end
  end

  context 'with block' do
    subject { object.each_with_index { |el, row, col| yields << [el, row, col]}}
    let(:yields) { [] }
    let(:expected) { [['a1', 0, 0], ['a2', 0, 1], ['b1', 1, 0], ['b2', 1, 1]] }

    it "" do
      expect { subject }.to change { yields }.
        from( [] ).
        to( expected )
    end
  end
end
