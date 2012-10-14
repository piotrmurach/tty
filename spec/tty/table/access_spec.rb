# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, 'access' do
  let(:rows) { [['a1', 'a2'], ['b1', 'b2']] }
  subject { TTY::Table.new :rows => rows }

  it { should respond_to(:element) }

  it { should respond_to(:component) }

  it { should respond_to(:at) }

  its([0,0]) { should == 'a1'}

  its([5,5]) { should be_nil }

  it 'raises error for negative indices' do
    expect { subject[-5,-5] }.to raise_error(IndexError)
  end

  context '#row' do
    it 'returns nil for wrong index' do
      subject.row(11).should be_nil
    end

    it 'gets row at index' do
      subject.row(1).should == rows[1]
    end

    it 'yields self for wrong index' do
      block = lambda { |el| [] << el }
      subject.row(11, &block).should eql subject
    end

    it 'yields row at index' do
      yields = []
      expect { subject.row(1).each { |el| yields << el } }.to change { yields }.
        from( [] ).
        to( rows[1] )
    end
  end

  context '#column' do
    it 'returns nil for wrong index' do
      subject.column(11).should be_nil
    end

    it 'gets column at index' do
      subject.column(0).should == ['a1', 'b1']
    end

    it 'yields self for wrong index' do
      block = lambda { |el| [] << el }
      subject.column(11, &block).should eql subject
    end

    it 'yields column at index' do
      yields = []
      expect { subject.column(1).each { |el| yields << el } }.to change { yields }.
        from( [] ).
        to( ['a2', 'b2'])
    end
  end
end
