# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#render' do
  let(:object) { described_class }
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows)   { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:basic_renderer)   { TTY::Table::Renderer::Basic }
  let(:ascii_renderer)   { TTY::Table::Renderer::ASCII }

  subject(:table) { object.new header, rows }

  it { should respond_to(:render) }

  context 'with block' do
    it 'allows to modify renderer in a block' do
      expected = nil
      block = lambda { |renderer| expected = renderer }
      table.render(&block)
      expect(expected).to be_kind_of(basic_renderer)
    end

    it 'sets renderer as block parameter' do
      expected = nil
      block = lambda { |renderer| expected = renderer }
      table.render(:ascii, &block)
      expect(expected).to be_kind_of(ascii_renderer)
    end
  end

  context 'with params' do
    it 'sets params without renderer' do
      TTY::Table::Renderer.should_receive(:render).with(table, {renderer: :basic})
      table.render(:basic)
    end

    it 'sets params with renderer' do
      TTY::Table::Renderer.should_receive(:render).with(table, {})
      table.render
    end
  end
end
