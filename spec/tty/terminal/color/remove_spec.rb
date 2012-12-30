# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Terminal::Color, '#remove' do
  let(:instance) { described_class.new }

  let(:string) { "This is a \e[1m\e[34mbold blue text\e[0m" }

  subject { instance.remove string }

  it 'remove color from string' do
    should == "This is a bold blue text"
  end

  context 'with octal in encapsulating brackets' do
    let(:string) { "\[\033[01;32m\]u@h \[\033[01;34m\]W $ \[\033[00m\]" }

    it { should == 'u@h W $ '}
  end

  context 'with octal without brackets' do
    let(:string) { "\033[01;32mu@h \033[01;34mW $ \033[00m" }

    it { should == 'u@h W $ '}
  end

  context 'with octal with multiple colors' do
    let(:string) { "\e[3;0;0;t\e[8;50;0t" }

    it { should == "" }
  end

  context 'with' do
    let(:string ) { "WARN. \x1b[1m&\x1b[0m ERR. \x1b[7m&\x1b[0m" }

    it { should == 'WARN. & ERR. &' }
  end

  context 'with escape byte' do
    let(:string) { "This is a \e[1m\e[34mbold blue text\e[0m" }

    it { should == "This is a bold blue text"}
  end
end
