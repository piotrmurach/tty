# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Field, '#lines' do
  let(:object) { described_class.new value }

  subject { object.lines }

  context 'with escaped value' do
    let(:value) { "Multi\nLine" }

    it { should eql(["Multi", "Line"]) }
  end

  context 'with unescaped value' do
    let(:value) { "Multi\\nLine" }

    it { should eql(["Multi\\nLine"]) }
  end
end
