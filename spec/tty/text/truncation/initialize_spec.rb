# encoding: utf-8

require 'spec_helper'

describe TTY::Text::Truncation, '#initialize' do
  let(:text) { "There go the ships; there is that Leviathan whom thou hast made to play therein."}

  let(:args) { [] }

  subject { described_class.new text, *args }

  it { expect(subject.text).to eq(text) }

  it { expect(subject.length).to eq(30) }

  it { expect(subject.separator).to be_nil }

  it { expect(subject.trailing).to eq('…') }

  context 'custom values' do
    let(:args) { [45, { separator: ' ', trailing: '...' }] }

    it { expect(subject.length).to eq(45) }

    it { expect(subject.separator).to eq(' ') }

    it { expect(subject.trailing).to eq('...') }
  end
end # initialize
