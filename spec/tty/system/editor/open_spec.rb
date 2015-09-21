# encoding: utf-8

require 'spec_helper'

describe TTY::System::Editor, '#open' do
  let(:file) { "hello.rb" }

  subject(:editor) { described_class }

  context 'when no editor' do
    before { allow(editor).to receive(:command).and_return(nil) }

    it 'raises error' do
      expect {
        editor.open(file)
      }.to raise_error(TTY::CommandInvocationError)
    end
  end

  context 'when editor'  do
    before { allow(editor).to receive(:command).and_return('vim') }

    it 'invokes editor' do
      invocable = double(:invocable, invoke: nil)
      expect(subject).to receive(:new).with(file).and_return(invocable)
      editor.open(file)
    end
  end
end
