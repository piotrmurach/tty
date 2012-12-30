# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Text::Wrapping, '#initialize' do
  let(:text) { "There go the ships; there is that Leviathan whom thou hast made to play therein."}

  let(:args) { [] }

  subject { described_class.new text, *args }

  its(:text)   { should == text }

  its(:width)  { should == 80 }

  its(:indent) { should == 0 }

  context 'custom values' do
    let(:args) { [45, { :indent => 5 }]}

    its(:width)  { should == 45 }

    its(:indent) { should == 5 }
  end
end # initialize
