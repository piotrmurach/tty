# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Operation::Wrapped, '#call' do
  let(:object) { described_class.new }
  let(:text) { 'ラドクリフ、マラソン五輪代表に1万m出場にも含み' }
  let(:row) { [TTY::Table::Field.new(text), TTY::Table::Field.new(text)] }

  context 'without column width' do
    it "doesn't wrap string" do
      object.call(row)
      expect(row[0]).to eql(text)
      expect(row[1]).to eql(text)
    end
  end

  context 'with column width' do
    let(:column_widths) { [12, 14] }

    it "truncates string" do
      object.call(row, :column_widths => column_widths)
      expect(row[0]).to eql("ラドクリフ、マラソン五輪\n代表に1万m出場にも含み")
      expect(row[1]).to eql("ラドクリフ、マラソン五輪代表\nに1万m出場にも含み")
    end
  end
end
