# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Border, '#new' do
  let(:row) { [] }
  subject(:instance) { klass.new row }

  context 'when abstract' do
    let(:klass) { described_class }

    specify { expect { instance }.to raise_error(NotImplementedError) }
  end

  context 'when concrete' do
    let(:klass) {
      Class.new do
        def initialize(row); end
      end
    }

    specify { expect { instance }.to_not raise_error() }

    it { should be_instance_of klass }
  end
end
