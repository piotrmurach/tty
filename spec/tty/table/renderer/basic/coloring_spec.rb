# encoding: utf-8

require 'spec_helper'

describe TTY::Table::Renderer::Basic, 'coloring' do
  let(:header)   { ['h1', 'h2'] }
  let(:rows)     { [['a1', 'a2'], ['b1', 'b2']] }
  let(:blue)     { "\e[34m" }
  let(:clear)    { "\e[0m" }
  let(:on_green) { "\e[42m"}
  let(:options)  { {filter: filter } }
  let(:table)    { TTY::Table.new(header, rows) }

  subject(:renderer) { described_class.new(table, options) }

  context 'with filter on all fields' do
    let(:filter) {
      proc { |val, row, col| TTY.terminal.color.set val, :blue, :on_green }
    }

    it 'colors all elements' do
      expect(renderer.render).to eql <<-EOS.normalize
        #{blue}#{on_green}h1#{clear} #{blue}#{on_green}h2#{clear}
        #{blue}#{on_green}a1#{clear} #{blue}#{on_green}a2#{clear}
        #{blue}#{on_green}b1#{clear} #{blue}#{on_green}b2#{clear}
      EOS
    end
  end

  context 'with filter only on header' do
    let(:filter) {
      proc { |val, row, col|
        row.zero? ?  TTY.terminal.color.set(val, :blue, :on_green) : val
      }
    }

    it 'colors only header' do
      expect(renderer.render).to eql <<-EOS.normalize
        #{blue}#{on_green}h1#{clear} #{blue}#{on_green}h2#{clear}
        a1 a2
        b1 b2
      EOS
    end
  end
end
