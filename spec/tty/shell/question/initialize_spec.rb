# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Shell::Question, '#initialize' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }
  let(:message) { 'Do you like me?' }

  subject { described_class.new shell }

  its(:shell)     { should == shell }

  its(:required)  { should be_false }

  its(:echo)      { should be_true }

  its(:mask)      { should be_false }

  its(:character) { should be_false }

  its(:modifier)  { should be_kind_of TTY::Shell::Question::Modifier }

  its(:validation) { should be_kind_of TTY::Shell::Question::Validation }

end # initialize
