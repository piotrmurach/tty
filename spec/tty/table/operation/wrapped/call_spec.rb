# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Operation::Wrapped, '#call' do
  let(:padding) { TTY::Table::Padder.parse }
  let(:object) { described_class.new(column_widths, padding) }
  let(:text)   { 'ラドクリフ、マラソン五輪代表に1万m出場にも含み' }
  let(:field)  { TTY::Table::Field.new(text) }

  context 'without column width' do
    let(:column_widths) { [] }

    it "doesn't wrap string" do
      object.call(field, 0, 0)
      expect(field.value).to eql(text)
    end
  end

  context 'with column width' do
    let(:column_widths) { [12, 14] }

    it "wraps string for 0 column" do
      object.call(field, 0, 0)
      expect(field.value).to eql("ラドクリフ、マラソン五輪\n代表に1万m出場にも含み")
    end

    it "wraps string for 1 column" do
      object.call(field, 0, 1)
      expect(field.value).to eql("ラドクリフ、マラソン五輪代表\nに1万m出場にも含み")
    end
  end
end
