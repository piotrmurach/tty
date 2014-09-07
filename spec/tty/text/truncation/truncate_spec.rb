# encoding: utf-8

require 'spec_helper'

describe TTY::Text::Truncation, '#truncate' do
  let(:separator) { nil }
  let(:options)   { { length: length, separator: separator, trailing: trailing } }
  let(:trailing)  { '…' }
  let(:object)    { described_class.new(text, options) }

  subject { object.truncate }

  context 'unicode support' do
    let(:text) { 'ラドクリフ、マラソン五輪代表に1万m出場にも含み' }

    context 'with zero length' do
      let(:length) { 0 }

      it { is_expected.to eq(text) }
    end

    context 'with nil length' do
      let(:length) { nil }

      it { is_expected.to eq(text) }
    end

    context 'with equal length' do
      let(:length) { text.length }

      it { is_expected.to eq(text) }
    end

    context 'with truncation' do
      let(:length) { 12 }

      it { is_expected.to eq("ラドクリフ、マラソン五#{trailing}")  }
    end

    context 'without truncation' do
      let(:length) { 100 }

      it { is_expected.to eq(text) }
    end

    context 'with separator' do
      let(:length) { 12 }
      let(:separator) { ' ' }

      it { is_expected.to eq("ラドクリフ、マラソン五#{trailing}") }
    end
  end

  context 'with custom trailing' do
    let(:text) { 'ラドクリフ、マラソン五輪代表に1万m出場にも含み' }
    let(:length) { 20 }
    let(:trailing) { '... (see more)' }

    it { is_expected.to eq("ラドクリフ、#{trailing}") }
  end

  context 'with separator' do
    let(:length) { 25 }
    let(:text) { "Immense as whales, the motion of whose vast bodies can in a peaceful calm trouble the ocean til it boil." }

    context 'blank' do
      let(:separator) { '' }

      it { is_expected.to eq("Immense as whales, the m#{trailing}") }
    end

    context 'space' do
      let(:separator) { ' ' }

      it { is_expected.to eq("Immense as whales, the…") }
    end
  end

  context 'with excape' do
    let(:text) { "This is a \e[1m\e[34mbold blue text\e[0m" }

    context 'removes ansi chars' do
      let(:options) { {escape: true} }

      it { expect(subject).to eq 'This is a bold blue text' }
    end

    context 'preserves ansi chars' do
      let(:options) { {escape: false, length: -1} }

      it { expect(subject).to eq text }
    end
  end
end # truncate
