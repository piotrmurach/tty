# encoding: utf-8

require 'spec_helper'

describe TTY::Table::Operation::AlignmentSet, '#new' do
  let(:object) { described_class }

  subject { object.new(argument) }

  context 'with no argument' do
    let(:argument) { [] }

    it { is_expected.to be_kind_of(Enumerable) }

    it { is_expected.to be_instance_of(object) }

    it { expect(subject.alignments).to eq([]) }
  end

  context 'with argument' do
    let(:argument) { [:center, :left] }

    it { is_expected.to be_instance_of(object) }

    it { expect(subject.alignments).to eq(argument) }
  end
end
