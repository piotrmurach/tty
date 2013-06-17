# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Terminal, '#page' do
  let(:text)   { "a\n"}
  let(:object) { described_class.new }

  it 'invokes pager page method' do
    object.pager.should_receive(:page).with(text)
    object.page(text)
  end
end
