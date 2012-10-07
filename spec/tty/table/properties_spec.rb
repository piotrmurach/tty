# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, 'properties' do
  let(:rows) {[['a1', 'a2', 'a3'], ['b1', 'b2', 'c3']] }
  subject { described_class.new :rows => rows, :renderer => :basic }

  its(:width) { should == 6 }

  its(:row_size) { should == 2 }

  its(:column_size)  { should == 3 }

  its(:size) { should == [2,3] }

  context 'no size' do
    let(:rows) { []  }

    its(:row_size)    { should == 0 }

    its(:column_size) { should == 0 }
  end
end
