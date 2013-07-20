# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#filter' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows)   { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:table)  { described_class.new(header, rows) }
  let(:filter) { Proc.new { |val, row, col|
      (col == 1 and row > 0) ? val.capitalize : val
    }
  }

  it 'filters rows' do
    table.render do |renderer|
      renderer.filter = filter
    end.should == <<-EOS.normalize
      h1 h2 h3
      a1 A2 a3
      b1 B2 b3
    EOS
  end
end
