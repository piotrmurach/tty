# encoding: utf-8

require 'spec_helper'

describe TTY::Terminal, '#page' do
  let(:text)   { "a\n"}

  subject(:terminal) { described_class.new }

  it 'invokes pager page method' do
    expect(terminal.pager).to receive(:page).with(text)
    terminal.page(text)
  end
end
