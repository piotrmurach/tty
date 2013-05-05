# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Header, '#set' do
  let(:object) { described_class }
  let(:attributes) { [:id, :name, :age] }

  subject { object.new }

  it 'sets the value' do
    subject[0] = :id
    expect(subject[0]).to eql(:id)
  end
end
