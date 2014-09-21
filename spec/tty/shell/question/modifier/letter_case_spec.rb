# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question::Modifier, '#letter_case' do
  let(:string) { 'text to modify' }

  subject { described_class.letter_case modifier, string}

  context 'when upper case' do
    let(:modifier) { :up }

    it { is_expected.to eq('TEXT TO MODIFY') }
  end

  context 'when lower case' do
    let(:modifier) { :down }

    it { is_expected.to eq('text to modify') }
  end

  context 'when capitalize' do
    let(:modifier) { :capitalize }

    it { is_expected.to eq('Text to modify') }
  end
end # lettercase
