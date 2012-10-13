# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic do
  let(:renderer) { TTY::Table::Renderer::Basic.new }
  let(:header) { ['Header1', 'Header2'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }

  subject { described_class.new }

  it { should respond_to(:render) }

  context '#extract_column_widths' do
    it 'calculates column widths' do
      rows = [['a1a', 'a2a2a2'], ['b1b1b', 'b2b2']]
      subject.extract_column_widths(rows).should == [5,6]
    end
  end

  context '#render' do
    it 'displays table without styling' do
      table = TTY::Table.new :header => header, :renderer => :basic
      table << rows[0]
      table << rows[1]
      table.to_s.should == <<-EOS.normalize
        a1 a2 a3
        b1 b2 b3
      EOS
    end

    it 'displays table according to widths' do
      rows = [['aaa1', 'a2'], ['b1', 'bb1']]
      table = TTY::Table.new header, rows, :renderer => :basic
      table.to_s.should == <<-EOS.normalize
        aaa1 a2 
        b1   bb1
      EOS
    end
  end
end
