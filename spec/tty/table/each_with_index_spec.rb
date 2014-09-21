# encoding: utf-8

require 'spec_helper'

describe TTY::Table, '.each_with_index' do
  let(:header) { ['Header1', 'Header2'] }
  let(:rows)   { [['a1', 'a2'], ['b1', 'b2']] }
  let(:field)  { TTY::Table::Field }

  let(:object) { described_class.new header, rows }

  context 'with no block' do
    subject { object.each_with_index }

    it { is_expected.to be_instance_of(to_enum.class) }

    it 'yields the expected values' do
      expect(subject.to_a).to eql(object.to_a)
    end
  end

  context 'with block' do
    let(:yields) { [] }

    subject { object.each_with_index { |el, row, col| yields << [el, row, col]}}

    context 'without header' do
      let(:header) { nil }

      let(:expected) {
        [ [field.new('a1'), 0, 0], [field.new('a2'), 0, 1],
          [field.new('b1'), 1, 0], [field.new('b2'), 1, 1] ]
      }

      it "yields rows with expected data" do
        expect { subject }.to change { yields }.
          from( [] ).
          to( expected )
      end
    end

    context 'with header' do

      let(:expected) {
        [ [field.new('Header1'), 0, 0], [field.new('Header2'), 0, 1],
          [field.new('a1'), 1, 0], [field.new('a2'), 1, 1],
          [field.new('b1'), 2, 0], [field.new('b2'), 2, 1] ]
      }

      it "yields header and rows with expected data" do
        expect { subject }.to change { yields }.
          from( [] ).
          to( expected )
      end
    end
  end
end
