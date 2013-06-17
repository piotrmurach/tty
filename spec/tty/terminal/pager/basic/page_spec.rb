# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Terminal::BasicPager, '#simple' do
  let(:input)    { StringIO.new }
  let(:output)   { StringIO.new }
  let(:shell)    { TTY::Shell.new(input, output) }
  let(:terminal) { TTY.terminal }
  let(:object)   { described_class }

  subject { object.new(text) }

  before {
    TTY.stub(:shell).and_return(shell)
    terminal.stub(:height).and_return(10)
  }

  context 'when no text' do
    let(:text) { "" }

    it "doesn't page text" do
      subject.page
      expect(output.string).to eql(text)
    end
  end

  context 'when text fits on screen' do
    let(:text) { "a\n" }

    it "doesn't page text not long enough" do
      subject.page
      expect(output.string).to eql(text)
    end
  end

  context "when text doesn't fit on screen" do
    let(:text) { "a\na\na\na\na\na\na\na\na\na\n" }

    it "continues paging when enter is pressed" do
      input << '\n'
      input.rewind
      subject.page
      expect(output.string).to eql("a\na\na\na\na\na\na\n\n#{object::PAGE_BREAK}\na\na\na\n")
    end

    it "stops paging when q is pressed" do
      input << 'q\n'
      input.rewind
      subject.page
      expect(output.string).to eql("a\na\na\na\na\na\na\n\n#{object::PAGE_BREAK}\n")
    end
  end
end
