# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer::Basic do
  let(:renderer) { TTY::Table::Renderer::Basic.new }
  let(:header) { ['Header1', 'Header2'] }
  let(:rows) { [['a1', 'a2', 'a3'], ['b1', 'b2', 'b3']] }

  context '#render' do
    it 'displays table without styling' do
      table = TTY::Table.new header, :renderer => :basic
      table << rows[0]
      table << rows[1]
      table.to_s.should == <<-EOS.normalize
        a1 a2 a3
        b1 b2 b3
      EOS
    end
  end
end
