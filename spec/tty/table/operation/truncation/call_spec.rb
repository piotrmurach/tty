# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Operation::Truncation, '#call' do
  let(:object) { described_class.new }
  let(:text) { '太丸ゴシック体' }
  let(:row) { [TTY::Table::Field.new(text), TTY::Table::Field.new(text)] }

  context 'without column width' do
    it "truncates string" do
      object.call(row)
      expect(row[0]).to eql("太丸ゴシック体")
      expect(row[1]).to eql("太丸ゴシック体")
    end
  end

  context 'with column width ' do
    let(:column_widths) { [3, 6] }

    it "truncates string" do
      object.call(row, :column_widths => column_widths)
      expect(row[0]).to eql('太丸…')
      expect(row[1]).to eql('太丸ゴシッ…')
    end
  end
end
