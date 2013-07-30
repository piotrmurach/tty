# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer, '#render' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows)   { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:table)  { TTY::Table.new(header, rows) }

  subject { described_class.render(table, {}, &block) }

  context 'when default' do
    let(:renderer)       { double(:renderer).as_null_object }
    let(:renderer_class) { double(:renderer_class) }
    let(:yielded)        { [] }
    let(:block)          { proc { |render| yielded << render } }

    before { described_class.stub(:select).and_return(renderer_class) }

    it 'creates renderer' do
      expect(renderer_class).to receive(:new).with(table, {}).and_return(renderer)
      subject
    end

    it 'yields renderer' do
      renderer_class.stub(:new).and_return(renderer)
      expect { subject }.to change { yielded}.from([]).to([renderer])
    end

    it 'calls render' do
      renderer_class.stub(:new).and_return(renderer)
      expect(renderer).to receive(:render)
      subject
    end
  end
end
