# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Color, '#set' do
  let(:string) { 'string' }

  it 'applies green text to string' do
    subject.set(string, :green).should == "\e[32m#{string}\e[0m"
  end

  it 'applies red text background to string' do
    subject.set(string, :on_red).should == "\e[41m#{string}\e[0m"
  end

  it 'applies style and color to string' do
    text = subject.set(string, :bold, :green)
    text.should == "\e[1m\e[32m#{string}\e[0m"
  end

  it 'applies style, color and background to string' do
    text = subject.set(string, :bold, :green, :on_blue)
    text.should == "\e[1m\e[32m\e[44m#{string}\e[0m"
  end

  it 'errors for unkown color' do
    expect { subject.set(string, :crimson) }.to raise_error(ArgumentError)
  end

end
