# encoding: utf-8

require 'spec_helper'

describe TTY::Text, '#wrap' do
  let(:text) { 'ラドクリフ、マラソン五輪代表に1万m出場にも含み' }
  let(:length) { 8 }
  let(:indent) { 4 }

  subject { described_class.wrap(text, :length => length, :indent => indent) }

  it { is_expected.to eq("    ラドクリフ、マラ\n    ソン五輪代表に1\n    万m出場にも含み") }
end # wrap
