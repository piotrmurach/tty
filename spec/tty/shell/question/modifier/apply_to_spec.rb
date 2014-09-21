# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question::Modifier, '#apply_to' do
  let(:instance) { described_class.new modifiers }
  let(:string)   { "Text to be modified"}

  subject { instance.apply_to string }

  context 'when no modifiers specified' do
    let(:modifiers) { [] }

    it { should == string }
  end

  context 'when modifiers specified' do
    let(:modifiers) { [:down, :capitalize] }

    it 'applies letter case modifications' do
      allow(described_class).to receive(:letter_case)
      subject
      expect(described_class).to have_received(:letter_case).
        with(modifiers, string)
    end

    it 'applies whitespace modifications' do
      allow(described_class).to receive(:whitespace)
      subject
      expect(described_class).to have_received(:whitespace).
        with(modifiers, string)
    end
  end
end # apply_to
