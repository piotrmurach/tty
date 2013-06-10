# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Text::Truncation, '#truncate' do
  let(:object) { described_class.new(text, options) }
  let(:separator) { nil }
  let(:trailing) { '…' }
  let(:options) { { :length => length, :separator => separator, :trailing => trailing }  }

  subject { object.truncate }

  context 'unicode support' do
    let(:text) { 'ラドクリフ、マラソン五輪代表に1万m出場にも含み' }

    context 'with zero length' do
      let(:length) { 0 }

      it { should == text }
    end

    context 'with nil length' do
      let(:length) { nil }

      it { should == text }
    end

    context 'with equal length' do
      let(:length) { text.length }

      it { should == text }
    end

    context 'with truncation' do
      let(:length) { 12 }

      it { should == "ラドクリフ、マラソン五#{trailing}"  }
    end

    context 'without truncation' do
      let(:length) { 100 }

      it { should == text }
    end

    context 'with separator' do
      let(:length) { 12 }
      let(:separator) { ' ' }

      it { should == "ラドクリフ、マラソン五#{trailing}" }
    end
  end

  context 'with custom trailing' do
    let(:text) { 'ラドクリフ、マラソン五輪代表に1万m出場にも含み' }
    let(:length) { 20 }
    let(:trailing) { '... (see more)' }

    it { should == "ラドクリフ、#{trailing}" }
  end

  context 'with separator' do
    let(:length) { 25 }
    let(:text) { "Immense as whales, the motion of whose vast bodies can in a peaceful calm trouble the ocean til it boil." }

    context 'blank' do
      let(:separator) { '' }

      it { should == "Immense as whales, the m#{trailing}"}
    end

    context 'space' do
      let(:separator) { ' ' }

      it { should == "Immense as whales, the…" }
    end
  end

end # truncate
