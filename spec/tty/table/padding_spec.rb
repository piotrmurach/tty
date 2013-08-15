# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, 'padding' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows)   { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:table)  { described_class.new(header, rows) }

  it '' do
    expect(table.render(:ascii) { |renderer|
      renderer.multiline = true
      renderer.padding.right = 2
      renderer.padding.top  = 1
    }).to eq <<-EOS.normalize
     +----+----+----+
     |    |    |    |
     |h1  |h2  |h3  |
     +----+----+----+
     |    |    |    |
     |a1  |a2  |a3  |
     |    |    |    |
     |b1  |b2  |b3  |
     +----+----+----+
    EOS
  end
end
