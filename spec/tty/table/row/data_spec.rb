# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Row, '#data' do
  let(:object) { described_class.new data, options }
  let(:data) { ['a'] }

  subject { object.data }

  context 'without attributes' do
    let(:options) {  {} }

    it { should be_instance_of(Hash) }

    it { should eql(0 => 'a') }
  end

  context 'with attributes' do
    let(:options) { { :attributes => [:id] } }

    it { should be_instance_of(Hash) }

    it { should eql(:id => 'a') }
  end
end
