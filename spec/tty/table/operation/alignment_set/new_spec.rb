# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Operation::AlignmentSet, '#new' do
  let(:object) { described_class }

  subject { object.new(argument) }

  context 'with no argument' do
    let(:argument) { nil }

    it { should be_instance_of(object) }

    its(:alignments) { should == [] }
  end

  context 'with argument' do
    let(:argument) { [:center, :left] }

    its(:alignments) { should == argument }
  end
end
