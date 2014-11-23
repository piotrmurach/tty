# encoding: utf-8

require 'spec_helper'

RSpec.describe TTY::Table::Renderer::Basic, 'coloring' do
  let(:header)   { ['h1', 'h2'] }
  let(:rows)     { [['a1', 'a2'], ['b1', 'b2']] }
  let(:clear)    { "\e[0m" }
  let(:options)  { {filter: filter } }
  let(:table)    { TTY::Table.new(header, rows) }
  let(:color)    { Pastel.new(enabled: true) }

  subject(:renderer) { described_class.new(table, options) }

  before { allow(Pastel).to receive(:new).and_return(color) }

  context 'with filter on all fields' do
    let(:filter) {
      proc { |val, row, col| color.decorate val, :blue, :on_green }
    }

    it 'colors all elements' do
      expect(renderer.render).to eql <<-EOS.normalize
        \e[34;42mh1#{clear} \e[34;42mh2#{clear}
        \e[34;42ma1#{clear} \e[34;42ma2#{clear}
        \e[34;42mb1#{clear} \e[34;42mb2#{clear}
      EOS
    end
  end

  context 'with filter only on header' do
    let(:filter) {
      proc { |val, row, col|
        row.zero? ?  color.decorate(val, :blue, :on_green) : val
      }
    }

    it 'colors only header' do
      expect(renderer.render).to eql <<-EOS.normalize
        \e[34;42mh1#{clear} \e[34;42mh2#{clear}
        a1 a2
        b1 b2
      EOS
    end
  end
end
