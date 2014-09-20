# encoding: utf-8

require 'spec_helper'

describe TTY::Table::Padder, '.to_s' do
  let(:object) { described_class }
  let(:value)  { [1,2,3,4] }

  subject { object.parse(value) }

  it 'prints string representation' do
    expect(subject.to_s).to eq('#<TTY::Table::Padder padding=[1, 2, 3, 4]>')
  end
end
