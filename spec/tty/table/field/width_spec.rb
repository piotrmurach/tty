# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Field, '#width' do
  let(:object) { described_class }

  subject { object.new value }

  context 'with only value' do
    let(:value) { 'foo' }

    its(:width) { should == 3 }
  end

  context 'with hash value' do
    let(:value) { "foo\nbaar" }

    its(:width) { should == 8 }
  end
end
