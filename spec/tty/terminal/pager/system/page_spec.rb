# encoding: utf-8

require 'spec_helper'

describe TTY::Terminal::SystemPager, '#simple' do
  let(:input)    { StringIO.new }
  let(:output)   { StringIO.new }
  let(:shell)    { TTY::Shell.new(input, output) }
  let(:terminal) { TTY.terminal }
  let(:object)   { described_class }

  subject(:pager) { object.new(text) }

  before {
    allow(TTY).to receive(:shell).and_return(shell)
    allow(IO).to receive(:pipe).and_return([input, output])
    allow(Kernel).to receive(:fork) { true }
  }

  context 'when text fits on screen' do
    let(:text) { "a\na\na\na\na\na\na\na\na\na\n" }

    it "doesn't page text not long enough" do
      expect(Kernel).to receive(:exec)
      expect(Kernel).to receive(:select)
      pager.page
    end
  end
end
