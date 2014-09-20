# encoding: utf-8

require 'spec_helper'

describe TTY::Table, '#renderer' do
  let(:object) { described_class }
  let(:header) { ['h1', 'h2'] }
  let(:rows)   { [['a1', 'a2'], ['b1', 'b2']] }

  subject { object.new(header, rows).renderer }

  it 'creates new renderer' do
    expect(subject).to be_kind_of(TTY::Table::Renderer::Basic)
  end

  it 'chains calls on renderer' do
    expect(subject.render).to eql("h1 h2\na1 a2\nb1 b2")
  end
end
