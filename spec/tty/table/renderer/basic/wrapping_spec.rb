# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic, 'wrapping' do
  let(:header) { ['header1', 'head2', 'h3'] }
  let(:rows) { [['a1111111', 'a222', 'a3333333'], ['b111', 'b2222222', 'b333333']]}
  let(:table) { TTY::Table.new header, rows }

  subject { described_class.new(table, options) }

  context 'without column widths' do
    let(:options) { {multiline: true} }

    it 'doesn\'t wrap the fields' do
      subject.render.should == <<-EOS.normalize
        header1  head2    h3      
        a1111111 a222     a3333333
        b111     b2222222 b333333 
      EOS
    end
  end

  context 'with column widths' do
    let(:options) { { column_widths: [3, 5, 7], multiline: true} }

    it 'wraps the fields' do
      subject.render.should == <<-EOS.normalize
        hea head2 h3     
        der              
        1                
        a11 a222  a333333
        111       3      
        11               
        b11 b2222 b333333
        1   222          
      EOS
    end
  end
end
