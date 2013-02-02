# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::BorderOptions, '#from' do

  subject(:options) { described_class.from hash }

  context 'when no hash' do
    let(:hash) { {} }

    it { expect(options.style).to be_nil }

    it { expect(options.separator).to be_nil }
  end

  context 'when hash' do
    let(:hash) { { :style => :red, :separator => :none } }

    it { expect(options).to be_kind_of(described_class) }

    it { expect(options.style).to eql :red }

    it { expect(options.separator).to eql :none }

    it { expect(options.characters).to eql({}) }
  end

end # from
