# encoding: utf-8

require 'spec_helper'

describe TTY::System::Editor, '#invoke' do
  let(:file) { "hello.rb" }
  let(:name) { "vim" }
  let(:object) { described_class }

  subject(:editor) { object.new(file) }

  before {
    allow(object).to receive(:command).and_return(name)
    allow(TTY::System).to receive(:unix?).and_return(true)
  }

  context 'when invokes' do
    before { allow(editor).to receive(:system).and_return(true) }

    it 'executes editor command' do
      editor.invoke
      expect(editor).to have_received(:system).with(name, file)
    end
  end

  context 'when fails to invoke' do

    before { allow(editor).to receive(:system).and_return(false) }

    it 'raises an error' do
      expect { editor.invoke }.to raise_error(TTY::CommandInvocationError)
    end
  end
end
