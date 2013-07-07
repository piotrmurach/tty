# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic, '#render' do
  let(:header) { ['h1', 'h2', 'h3'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }
  let(:table) { TTY::Table.new header, rows }

  subject { described_class.new(table) }

  context 'with rows' do
    let(:table) { TTY::Table.new rows }

    it 'displays table without styling' do
      subject.render.should == <<-EOS.normalize
        a1 a2 a3
        b1 b2 b3
      EOS
    end
  end

  context 'with header and rows' do
    it 'displays table with header' do
      subject.render.should == <<-EOS.normalize
        h1 h2 h3
        a1 a2 a3
        b1 b2 b3
      EOS
    end
  end

  context 'with short header' do
    let(:header) { ['h1', 'h2'] }
    let(:rows)   { [['aaa1', 'a2'], ['b1', 'bb1']] }

    it 'displays table according to widths' do
      subject.render.should == <<-EOS.normalize
        h1   h2 
        aaa1 a2 
        b1   bb1
      EOS
    end
  end

  context 'with long header' do
    let(:header)  { ['header1', 'header2', 'header3'] }

    it 'header greater than row sizes' do
      subject.render.should == <<-EOS.normalize
        header1 header2 header3
        a1      a2      a3     
        b1      b2      b3     
      EOS
    end
  end
end
