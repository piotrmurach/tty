# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#empty?' do
  let(:header) { ['Header1', 'Header2'] }
  let(:object) { described_class.new header, rows }

  subject { object.empty? }

  context 'with rows containing no entries' do
    let(:rows) { [] }

    it { should be_true }
  end

  context 'with rows containing an entry' do
    let(:rows) { [['a1']] }

    it { should be_false }
  end
end

