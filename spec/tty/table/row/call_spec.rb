# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Row, '#call' do
  let(:object) { described_class.new(data) }

  subject { object[attribute] }

  context 'when integer' do
    let(:data) { ['a', 'b'] }

    let(:attribute) { 1 }

    it { should == 'b' }
  end

  context 'when symbol' do
    let(:data) { {:id => 1} }

    context 'when hash access' do
      let(:attribute) { :id }

      it { should == 1 }
    end

    context 'when array access' do
      let(:attribute) { 0 }

      it { should == 1}
    end
  end

  context 'when unkown attribute' do
    let(:data) { {:id => 1} }

    let(:attribute) { :other }

    specify { expect { subject }.to raise_error(TTY::UnknownAttributeError) }
  end
end
