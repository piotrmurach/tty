# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::ASCII, 'resizing' do
  let(:header)  { ['h1', 'h2', 'h3'] }
  let(:rows)    { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:table)   { TTY::Table.new(header, rows) }

  subject(:renderer) { described_class.new(table, options) }

  context 'when resizing even columns' do
    let(:options) { {width: 16, resize: true} }

    it 'resizes each column' do
      expect(renderer.render).to eql <<-EOS.normalize
       +----+----+----+
       |h1  |h2  |h3  |
       +----+----+----+
       |a1  |a2  |a3  |
       |b1  |b2  |b3  |
       +----+----+----+
      EOS
    end
  end

  context 'when resizing uneven columns' do
    let(:header)  { ['h1', 'h2', 'h3'] }
    let(:rows)    { [['aaa1', 'aa2', 'aaaaaaa3'], ['b1', 'b2', 'b3']] }
    let(:options) { {width: 32, resize: true} }

    it 'resizes each column' do
      expect(renderer.render).to eql <<-EOS.normalize
       +--------+-------+------------+
       |h1      |h2     |h3          |
       +--------+-------+------------+
       |aaa1    |aa2    |aaaaaaa3    |
       |b1      |b2     |b3          |
       +--------+-------+------------+
      EOS
    end
  end
end
