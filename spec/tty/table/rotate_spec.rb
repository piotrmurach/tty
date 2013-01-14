# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#rotate' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }

  subject { described_class.new(header, rows) }

  before { subject.orientation = :horizontal }

  context 'with default' do
    context 'without header' do
      let(:header) { nil }

      it 'preserves orientation' do
        expect(subject.header).to be_nil
        expect(subject.rotate.to_a).to eql rows
      end
    end

    context 'with header' do
      it 'preserves orientation' do
        expect(subject.header).to eql header
        expect(subject.rotate.to_a).to eql rows
      end
    end
  end

  context 'with no header' do
    let(:header) { nil }

    it 'rotates the rows' do
      subject.orientation = :vertical
      expect(subject.rotate.to_a).to eql [
        ['a1', 'b1'],
        ['a2', 'b2'],
        ['a3', 'b3'],
      ]
      expect(subject.header).to be_nil
    end

    it 'rotates the rows back' do
      subject.orientation = :vertical
      subject.rotate
      subject.orientation = :horizontal
      expect(subject.rotate.to_a).to eql rows
      expect(subject.header).to eql header
    end
  end

  context 'with header' do
    it 'rotates the rows and merges header' do
      subject.orientation = :vertical
      expect(subject.rotate.to_a).to eql [
        ['h1', 'a1', 'b1'],
        ['h2', 'a2', 'b2'],
        ['h3', 'a3', 'b3'],
      ]
      expect(subject.header).to be_empty
    end

    it 'rotates the rows and header back' do
      subject.orientation = :vertical
      subject.rotate
      subject.orientation = :horizontal
      expect(subject.rotate.to_a).to eql rows
      expect(subject.rotate.header).to eql header
    end
  end
end
