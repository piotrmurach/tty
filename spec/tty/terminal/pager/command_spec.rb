# encoding: utf-8

require 'spec_helper'

describe TTY::Terminal::Pager, '#command' do
  let(:pager) { 'vim' }

  subject { described_class }

  context 'when custom command' do
    it 'searches available commands' do
      expect(subject).to receive(:available).with(pager)
      subject.command(pager)
    end
  end
end
