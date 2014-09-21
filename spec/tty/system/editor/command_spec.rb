# encoding: utf-8

require 'spec_helper'

describe TTY::System::Editor, '#command' do
  let(:editor) { 'vim' }

  subject { described_class }

  context 'when custom command' do
    it 'searches available commands' do
      allow(subject).to receive(:available)
      subject.command(editor)
      expect(subject).to have_received(:available).with(editor)
    end
  end
end
