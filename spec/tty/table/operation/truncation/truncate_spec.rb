# encoding: utf-8

require 'spec_helper'

describe TTY::Table::Operation::Truncation, '#truncate' do
  let(:instance) { described_class.new [] }
  let(:text)     { '太丸ゴシック体' }

  subject { instance.truncate(text, width) }

  context 'without shortening' do
    let(:width) { 8 }

    it { is_expected.to eq(text) }
  end

  context 'with shortening' do
    let(:width) { 5 }

    it { is_expected.to eq('太丸ゴシ…') }
  end
end
