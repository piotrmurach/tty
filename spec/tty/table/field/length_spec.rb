# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Field, '#lines' do
  let(:object) { described_class.new value }

  subject { object.length }

  context 'with escaped value' do
    let(:value) { "Multi\nLine" }

    it { should eql(5) }
  end

  context 'with unescaped value' do
    let(:value) { "Multi\\nLine" }

    it { should eql(11) }
  end
end
