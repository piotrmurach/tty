# encoding: utf-8

require 'spec_helper'

describe TTY::Terminal, '#color' do

  it { expect(subject.color).to be_a(TTY::Terminal::Color) }

  it 'delegates color handling' do
    string = 'text'
    expect(subject.color.set(string, :red)).to eq("\e[31m#{string}\e[0m")
  end
end
