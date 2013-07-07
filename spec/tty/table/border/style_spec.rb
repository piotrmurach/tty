# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, 'with style' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }

  subject(:table) { described_class.new(header, rows) }

  context 'when default' do
    let(:renderer) { :basic }

    it "sets through hash" do
      table.border :style => :red
      expect(table.border.style).to eql :red
    end

    it "sets through attribute" do
      table.border.style = :red
      expect(table.border.style).to eql :red
    end

    it "renders without color" do
      table.to_s.should == <<-EOS.normalize
        h1 h2 h3
        a1 a2 a3
        b1 b2 b3
      EOS
    end
  end

  context 'when ascii' do
    let(:renderer) { :ascii }
    let(:red) { "\e[31m" }
    let(:clear) { "\e[0m" }

    it "renders border in color" do
      table.border.style= :red

      table.render(renderer).should == <<-EOS.normalize
        #{red}+--+--+--+#{clear}
        #{red}|#{clear}h1#{red}|#{clear}h2#{red}|#{clear}h3#{red}|#{clear}
        #{red}+--+--+--+#{clear}
        #{red}|#{clear}a1#{red}|#{clear}a2#{red}|#{clear}a3#{red}|#{clear}
        #{red}|#{clear}b1#{red}|#{clear}b2#{red}|#{clear}b3#{red}|#{clear}
        #{red}+--+--+--+#{clear}
      EOS
    end
  end

  context 'when unicode' do
    let(:renderer) { :unicode }
    let(:red) { "\e[31m" }
    let(:clear) { "\e[0m" }

    it "renders each row" do
      table.border.style= :red
      table.render(renderer).should == <<-EOS.normalize
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
