# encoding: utf-8

require 'spec_helper'

describe TTY::Text::Wrapping, '#initialize' do
  let(:text) { "There go the ships; there is that Leviathan whom thou hast made to play therein."}

  let(:args) { [] }

  subject(:wrapping) { described_class.new text, *args }

  it { expect(wrapping.text).to eq(text) }

  it { expect(wrapping.length).to eq(80) }

  it { expect(wrapping.indent).to eq(0) }

  context 'custom values' do
    let(:args) { [45, { :indent => 5 }]}

    it { expect(wrapping.length).to eq(45) }

    it { expect(wrapping.indent).to eq(5) }
  end
end # initialize
