# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#data' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows)   { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }

  subject { described_class.new header, rows }

  it 'gets all table data' do
    expect(subject.data).to eql([header] + rows)
  end
end
