# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#eql?' do
  subject { object.eql?(other) }
  let(:object) { described_class.new }

  context 'with the same object' do
    let(:other) { object }

    it { should be_true }

    it 'is symmetric' do
      should eql(other.eql?(object))
    end
  end

  context 'with an equivalent object' do
    let(:other) { object.dup }

    it { should be_true }

    it 'is symmetric' do
      should eql(other.eql?(object))
    end
  end
end
