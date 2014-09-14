# encoding: utf-8

require 'spec_helper'

describe TTY::Table::Indentation, '#insert_indent' do
  let(:indent) { 2 }
  let(:renderer) { double(:renderer, indent: indent) }
  let(:object)  { described_class.new(renderer) }

  subject { object.insert_indent(part) }

  context 'when enumerable' do
    let(:part) { ['line1'] }

    it 'inserts indentation for each element' do
      expect(subject[0]).to eql('  line1')
    end
  end

  context 'when string' do
    let(:part) { 'line1' }

    it 'inserts indentation' do
      expect(subject).to eql('  line1')
    end
  end
end
