# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Operations, '#new' do
  let(:object) { described_class }
  let(:row) { [1,2,3] }
  let(:table) { TTY::Table.new :rows => [row] }
  let(:callable) {
    Class.new do
      def call(row, options)
        row.map! { |r| r + 1}
      end
    end
  }
  let(:instance) { callable.new }

  subject { object.new table }

  before {
    subject.add_operation(:alignment, instance)
  }

  it 'stores away operations' do
    expect(subject.operations).to eql({:alignment => [instance]})
  end

  it 'runs selected operations' do
    subject.run_operations(:alignment, row)
    expect(row).to eql([2,3,4])
  end
end
