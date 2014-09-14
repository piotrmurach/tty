# encoding: utf-8

require 'spec_helper'

describe TTY::Table::Field, '#width' do
  let(:object) { described_class }

  let(:instance) { object.new(value) }

  subject { instance.width }

  context 'with only value' do
    let(:value) { 'foo' }

    it { is_expected.to eql(3) }
  end

  context 'with hash value' do
    let(:value) { "foo\nbaar" }

    it { is_expected.to eql(8) }
  end
end
