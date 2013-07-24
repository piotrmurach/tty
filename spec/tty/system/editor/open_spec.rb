# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::System::Editor, '#open' do
  let(:file) { "hello.rb" }

  subject { described_class }

  context 'when no editor' do
    before { subject.stub(:command).and_return(nil) }

    it 'raises error' do
      expect { subject.open(file) }.to raise_error(TTY::CommandInvocationError)
    end
  end

  context 'when editor'  do
    before { subject.stub(:command).and_return('vim') }

    it 'invokes editor' do
      invocable = double(:invocable, :invoke => nil)
      subject.should_receive(:new).with(file).and_return(invocable)
      subject.open(file)
    end
  end
end
