# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Shell::Question::Modifier, '#whitespace' do
  let(:string) { "  text\t \n  to\t   modify\r\n" }

  subject { described_class.whitespace modifier, string}

  context 'when stripping whitespace' do
    let(:modifier) { :trim }

    it { should == "text\t \n  to\t   modify" }
  end

  context 'when chomping whitespace' do
    let(:modifier) { :chomp }

    it { should == "  text\t \n  to\t   modify" }
  end

  context 'when capitalize' do
    let(:modifier) { :collapse }

    it { should == " text to modify " }
  end

  context 'when removing whitespace' do
    let(:modifier) { :remove }

    it { should == "texttomodify" }
  end
end
