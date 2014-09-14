# encoding: utf-8

require 'spec_helper'

describe TTY::Table::Border, '#new' do
  let(:row) { [] }

  subject(:instance) { klass.new row }

  context 'when abstract' do
    let(:klass) { described_class }

    it { expect { instance }.to raise_error(NotImplementedError) }
  end

  context 'when concrete' do
    let(:klass) {
      Class.new do
        def initialize(row); end
      end
    }

    it { expect { instance }.to_not raise_error() }

    it { is_expected.to be_instance_of klass }
  end
end
