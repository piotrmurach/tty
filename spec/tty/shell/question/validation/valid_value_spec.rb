# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question::Validation, '#valid_value?' do
  let(:validation) { /^[^\.]+\.[^\.]+/ }
  let(:instance) { described_class.new validation }

  subject { instance.valid_value?(value) }

  context '' do
    let(:value) { nil }

    it { is_expected.to eq(false) }
  end

  context 'when the value matches validation' do
    let(:value) { 'piotr.murach' }

    it { is_expected.to eq(true) }
  end

  context 'when the value is not matching validation' do
    let(:value)  { 'piotrmurach' }

    it { expect { subject }.to raise_error(TTY::InvalidArgument) }
  end
end
