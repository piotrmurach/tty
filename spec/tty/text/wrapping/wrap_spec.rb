# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Text::Wrapping, '#wrap' do
  let(:instance) { described_class.new }
  let(:indent) { 0 }
  let(:options) { { :length => length, :indent => indent } }

  subject { described_class.new(text, options).wrap }

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

    context 'without wrapping' do
      let(:length) { 8 }

      it { should == "ラドクリフ、マラ\nソン五輪代表に1\n万m出場にも含み" }
    end

    context 'with wrapping' do
      let(:length) { 100 }

      it { should == text }
    end
  end

  context 'ascii long text' do
    let(:length) { 45 }
    let(:text) { "What of it, if some old hunks of a sea-captain orders me to get a broom
    and sweep down the decks? What does that indignity amount to, weighed,
    I mean, in the scales of the New Testament? Do you think the archangel
    Gabriel thinks anything the less of me, because I promptly and
    respectfully obey that old hunks in that particular instance? Who ain't
    a slave? Tell me that. Well, then, however the old sea-captains may
    order me about--however they may thump and punch me about, I have the
    satisfaction of knowing that it is all right;
    " }

    it { should == <<-EOS.normalize
    What of it, if some old hunks of a\n sea-captain orders me to get a broom
    and sweep down the decks? What does that\n indignity amount to, weighed,
    I mean, in the scales of the New Testament?\n Do you think the archangel
    Gabriel thinks anything the less of me,\n because I promptly and
    respectfully obey that old hunks in that\nparticular instance? Who ain't
    a slave? Tell me that. Well, then, however\n the old sea-captains may
    order me about--however they may thump and\n punch me about, I have the
    satisfaction of knowing that it is all right;\n
      EOS
    }
  end

  context 'with indent' do
    let(:text) { 'ラドクリフ、マラソン五輪代表に1万m出場にも含み' }
    let(:length) { 8 }
    let(:indent) { 4 }

    it { should == "    ラドクリフ、マラ\n    ソン五輪代表に1\n    万m出場にも含み" }
  end

  context 'with ansi colors' do
    let(:text) { "\[\033[01;32m\]Hey have\[\033[01;34m\]some cake\[\033[00m\]" }
    let(:length) { 6 }

    it { should == "\[\033[01;32m\]Hey have\[\033[01;34m\]some\ncake\[\033[00m\]" }
  end

end # wrap
