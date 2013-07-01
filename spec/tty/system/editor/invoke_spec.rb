# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::System::Editor, '#invoke' do
  let(:file) { "hello.rb" }
  let(:editor) { "vim" }
  let(:object) { described_class }

  subject { object.new(file) }

  before {
    object.stub(:editor).and_return(editor)
    TTY::System.stub(:unix?).and_return(true)
  }

  after {
    TTY::System.unstub(:unix?)
  }

  context 'when invokes' do
    before { subject.stub(:system).and_return(true) }

    it 'executes editor command' do
      subject.should_receive(:system).with(editor, file)
      subject.invoke
    end
  end

  context 'when fails to invoke' do

    before { subject.stub(:system).and_return(false) }

    it 'raises an error' do
      expect { subject.invoke }.to raise_error(TTY::CommandInvocationError)
    end
  end
end
