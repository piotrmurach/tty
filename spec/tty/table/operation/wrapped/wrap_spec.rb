# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Operation::Wrapped, '#wrap' do
  let(:instance) { described_class.new [] }
  let(:text) { 'ラドクリフ、マラソン五輪代表に1万m出場にも含み' }

  subject { instance.wrap(text, width) }

  context 'without wrapping' do
    let(:width) { 8 }

    it { should == "ラドクリフ、マラ\nソン五輪代表に1\n万m出場にも含み" }
  end

  context 'with wrapping' do
    let(:width) { 100 }

    it { should == text }
  end
end
