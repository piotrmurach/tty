# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Terminal, '#color' do

  it { should respond_to(:color) }

  its(:color) { should be_kind_of TTY::Terminal::Color}

  it 'delegates color handling' do
    string = 'text'
    subject.color.set(string, :red).should == "\e[31m#{string}\e[0m"
  end
end
