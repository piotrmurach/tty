# encoding: utf-8

require 'spec_helper'

RSpec.describe TTY::Terminal, '#color' do

  it { expect(subject.color).to be_a(Pastel::Delegator) }

  it 'delegates color handling' do
    string = 'text'
    expect(subject.color.decorate(string, :red)).to eq("\e[31m#{string}\e[0m")
  end
end
