# encoding: utf-8

require 'spec_helper'

describe TTY::Table::Field, '#length' do
  let(:object) { described_class.new value }

  subject { object.length }

  context 'with escaped value' do
    let(:value) { "Multi\nLine" }

    it { is_expected.to eql(5) }
  end

  context 'with unescaped value' do
    let(:value) { "Multi\\nLine" }

    it { is_expected.to eql(11) }
  end
end
