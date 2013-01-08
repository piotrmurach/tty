# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#to_s' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:renderer) { :basic }

  subject { described_class.new header, rows, :renderer => renderer }

  context 'without renderer' do
    let(:renderer) { nil }

    it 'displayes basic table' do
      subject.to_s.should == <<-EOS.normalize
        h1 h2 h3
        a1 a2 a3
        b1 b2 b3
      EOS
    end
  end

  context 'without border' do
    it 'displays table' do
      subject.to_s.should == <<-EOS.normalize
        h1 h2 h3
        a1 a2 a3
        b1 b2 b3
      EOS
    end
  end

  context 'with ascii border' do
    let(:renderer) { :ascii }

    it 'displays table' do
      subject.to_s.should == <<-EOS.normalize
        +--+--+--+
        |h1|h2|h3|
        +--+--+--+
        |a1|a2|a3|
        |b1|b2|b3|
        +--+--+--+
      EOS
    end
  end

  context 'with unicode border' do
    let(:renderer) { :unicode}

    it 'displays table' do
      subject.to_s.should == <<-EOS.normalize
        ┌──┬──┬──┐
        │h1│h2│h3│
        ├──┼──┼──┤
        │a1│a2│a3│
        │b1│b2│b3│
        └──┴──┴──┘
      EOS
    end
  end
end # to_s
