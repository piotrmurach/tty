#  encoding: utf-8

require 'spec_helper'

describe TTY::Table::Renderer, 'with style' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows)   { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:table)  { TTY::Table.new(header, rows) }
  let(:color)  { Pastel.new(enabled: true) }

  subject(:renderer) { described_class.select(type).new(table) }

  before { allow(Pastel).to receive(:new).and_return(color) }

  context 'when basic renderer' do
    let(:type) { :basic }

    it "sets through hash" do
      renderer.border(style: :red)
      expect(renderer.border.style).to eql(:red)
    end

    it "sets through attribute" do
      renderer.border.style = :red
      expect(renderer.border.style).to eql :red
    end

    it "renders without color" do
      expect(renderer.render).to eq <<-EOS.normalize
        h1 h2 h3
        a1 a2 a3
        b1 b2 b3
      EOS
    end
  end

  context 'when ascii renderer' do
    let(:type)  { :ascii }
    let(:red)   { "\e[31m" }
    let(:clear) { "\e[0m" }

    it "renders border in color" do
      renderer.border.style= :red
      expect(renderer.render).to eq <<-EOS.normalize
        #{red}+--+--+--+#{clear}
        #{red}|#{clear}h1#{red}|#{clear}h2#{red}|#{clear}h3#{red}|#{clear}
        #{red}+--+--+--+#{clear}
        #{red}|#{clear}a1#{red}|#{clear}a2#{red}|#{clear}a3#{red}|#{clear}
        #{red}|#{clear}b1#{red}|#{clear}b2#{red}|#{clear}b3#{red}|#{clear}
        #{red}+--+--+--+#{clear}
      EOS
    end
  end

  context 'when unicode renderer' do
    let(:type)  { :unicode }
    let(:red)   { "\e[31m" }
    let(:clear) { "\e[0m" }

    it "renders each row" do
      renderer.border.style= :red
      expect(renderer.render).to eq <<-EOS.normalize
        #{red}┌──┬──┬──┐#{clear}
        #{red}│#{clear}h1#{red}│#{clear}h2#{red}│#{clear}h3#{red}│#{clear}
        #{red}├──┼──┼──┤#{clear}
        #{red}│#{clear}a1#{red}│#{clear}a2#{red}│#{clear}a3#{red}│#{clear}
        #{red}│#{clear}b1#{red}│#{clear}b2#{red}│#{clear}b3#{red}│#{clear}
        #{red}└──┴──┴──┘#{clear}
      EOS
    end
  end
end
