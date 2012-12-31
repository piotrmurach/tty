# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Text::Truncation, '#initialize' do
  let(:text) { "There go the ships; there is that Leviathan whom thou hast made to play therein."}

  let(:args) { [] }

  subject { described_class.new text, *args }

  its(:text)   { should == text }

  its(:length) { should == 30 }

  its(:separator) { should be_nil }

  its(:trailing) { should == '…' }

  context 'custom values' do
    let(:args) { [45, { :separator => ' ', :trailing => '...' }]}

    its(:length) { should == 45 }

    its(:separator) { should == ' ' }

    its(:trailing) { should == '...' }
  end
end # initialize
