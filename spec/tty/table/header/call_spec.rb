# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Header, '#call' do
  let(:object) { described_class.new(attributes) }
  let(:attributes) { [:id, :name, :age] }

  subject { object.call(attribute) }

  context 'with a known attribute' do
    context 'when symbol' do
      let(:attribute) { :age }

      it { should == 2 }
    end

    context 'when integer' do
      let(:attribute) { 1 }

      it { should == :name }
    end
  end

  context 'with an unknown attribute' do
    let(:attribute) { :mine }

    specify { expect { subject }.to raise_error(TTY::UnknownAttributeError, "the header 'mine' is unknown")}
  end
end
