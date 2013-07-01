# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::System::Editor, '#command' do
  let(:editor) { 'vim' }

  subject { described_class }

  context 'when custom command' do
    it 'searches available commands' do
      subject.should_receive(:available).with(editor)
      subject.command(editor)
    end
  end
end
