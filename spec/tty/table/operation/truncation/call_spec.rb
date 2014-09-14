# encoding: utf-8

require 'spec_helper'

describe TTY::Table::Operation::Truncation, '#call' do
  let(:object) { described_class.new column_widths }
  let(:text)   { '太丸ゴシック体' }
  let(:field)  { TTY::Table::Field.new(text) }

  context 'without column width' do
    let(:column_widths) { [] }

    it "truncates string" do
      object.call(field, 0, 0)
      expect(field.value).to eql(text)
    end
  end

  context 'with column width ' do
    let(:column_widths) { [3, 6] }

    it "truncates string for 0 column" do
      object.call(field, 0, 0)
      expect(field.value).to eql('太丸…')
    end

    it "truncates string for 1 column" do
      object.call(field, 0, 1)
      expect(field.value).to eql('太丸ゴシッ…')
    end
  end
end
