# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Shell::Question::Modifier, '#apply_to' do
  let(:instance) { described_class.new modifiers }
  let(:string) { "Text to be modified"}

  subject { instance.apply_to string }

  context 'when no modifiers specified' do
    let(:modifiers) { [] }

    it { should == string }
  end

  context 'when modifiers specified' do
    let(:modifiers) { [:down, :capitalize] }

    it 'applies letter case modifications' do
      described_class.should_receive(:letter_case).with(modifiers, string)
      subject
    end

    it 'applies whitespace modifications' do
      described_class.should_receive(:whitespace).with(modifiers, string)
      subject
    end
  end
end # apply_to
