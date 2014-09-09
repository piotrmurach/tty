# encoding: utf-8

require 'spec_helper'

describe TTY::Table::Header, '#new' do
  let(:object) { described_class }

  context 'with no arguments' do
    subject { object.new }

    it { is_expected.to be_instance_of(object) }

    it { is_expected.to be_empty }
  end

  context 'with attributes' do
    subject { object.new(attributes) }

    let(:attributes) { ['id', 'name', 'age'] }

    it { is_expected.to be_instance_of(object) }

    it { is_expected == attributes }
  end
end
