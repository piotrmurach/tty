# encoding: utf-8

require 'spec_helper'

describe TTY::Shell, '#print_table' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:header) { ['h1', 'h2'] }
  let(:rows) { [['a1', 'a2'], ['b1', 'b2']] }

  subject(:shell) { TTY::Shell.new(input, output) }

  it 'prints a table' do
    shell.print_table header, rows, :renderer => :ascii
    expect(output.string).to eql <<-EOS.normalize
        +--+--+
        |h1|h2|
        +--+--+
        |a1|a2|
        |b1|b2|
        +--+--+\n
    EOS
  end
end # print_table
