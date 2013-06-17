# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Terminal::SystemPager, '#simple' do
  let(:input)    { StringIO.new }
  let(:output)   { StringIO.new }
  let(:shell)    { TTY::Shell.new(input, output) }
  let(:terminal) { TTY.terminal }
  let(:object)   { described_class }

  subject { object.new(text) }

  before {
    TTY.stub(:shell).and_return(shell)
    IO.stub(:pipe).and_return([input, output])
    Kernel.stub(:fork) { true }
  }

  context 'when text fits on screen' do
    let(:text) { "a\na\na\na\na\na\na\na\na\na\n" }

    it "doesn't page text not long enough" do
      Kernel.should_receive(:exec)
      Kernel.should_receive(:select)
      subject.page
    end
  end
end
