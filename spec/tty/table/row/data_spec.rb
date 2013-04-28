# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Row, '#data' do
  let(:object) { described_class.new data, header }
  let(:data) { ['a'] }

  subject { object.to_hash }

  context 'without attributes' do
    let(:header) { nil }

    it { should be_instance_of(Hash) }

    it { should eql(0 => 'a') }
  end

  context 'with attributes' do
    let(:header) { [:id] }

    it { should be_instance_of(Hash) }

    it { should eql(:id => 'a') }
  end
end
