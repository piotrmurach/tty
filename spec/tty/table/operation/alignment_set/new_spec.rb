# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Operation::AlignmentSet, '#new' do
  let(:object) { described_class }

  subject { object.new(argument) }

  context 'with no argument' do
    let(:argument) { [] }

    it { should be_kind_of(Enumerable) }

    it { should be_instance_of(object) }

    its(:alignments) { should == [] }
  end

  context 'with argument' do
    let(:argument) { [:center, :left] }

    it { should be_instance_of(object) }

    its(:alignments) { should == argument }
  end
end
