# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Shell::Question::Modifier, '#letter_case' do
  let(:string) { 'text to modify' }

  subject { described_class.letter_case modifier, string}

  context 'when upper case' do
    let(:modifier) { :up }

    it { should == 'TEXT TO MODIFY' }
  end

  context 'when lower case' do
    let(:modifier) { :down }

    it { should == 'text to modify'}
  end

  context 'when capitalize' do
    let(:modifier) { :capitalize }

    it { should == 'Text to modify'}
  end
end # lettercase
