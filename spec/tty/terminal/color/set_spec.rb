# encoding: utf-8

require 'spec_helper'

describe TTY::Terminal::Color, '#set' do
  let(:string) { 'string' }

  it 'applies green text to string' do
    expect(subject.set(string, :green)).to eq("\e[32m#{string}\e[0m")
  end

  it 'applies red text background to string' do
    expect(subject.set(string, :on_red)).to eq("\e[41m#{string}\e[0m")
  end

  it 'applies style and color to string' do
    text = subject.set(string, :bold, :green)
    expect(text).to  eq("\e[1m\e[32m#{string}\e[0m")
  end

  it 'applies style, color and background to string' do
    text = subject.set(string, :bold, :green, :on_blue)
    expect(text).to eq("\e[1m\e[32m\e[44m#{string}\e[0m")
  end

  it 'errors for unkown color' do
    expect { subject.set(string, :crimson) }.to raise_error(ArgumentError)
  end
end
