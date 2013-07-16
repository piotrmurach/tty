# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Operation::Escape, '#call' do
  let(:object) { described_class }
  let(:text)   { "太丸\nゴシ\tック体\r" }
  let(:field)  { TTY::Table::Field.new(text) }

  subject { object.new }

  it 'changes field value' do
    subject.call(field, 0, 0)
    expect(field.value).to eql("太丸\\nゴシ\\tック体\\r")
  end
end
