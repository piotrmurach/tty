# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#renderer' do
  let(:basic_renderer)   { TTY::Table::Renderer::Basic }
  let(:unicode_renderer) { TTY::Table::Renderer::Unicode }

  before do
    TTY::Table.renderer = basic_renderer
  end

  after do
    TTY::Table.renderer = basic_renderer
  end

  it { should respond_to(:render) }

  it 'sets basic renderer' do
    TTY::Table.renderer.should be TTY::Table::Renderer::Basic
  end

  it 'has instance renderer' do
    table = TTY::Table.new
    table.renderer.should be_kind_of(basic_renderer)
  end

  it 'allows to set instance renderer' do
    table = TTY::Table.new :renderer => :unicode
    table.renderer.should be_kind_of(unicode_renderer)
  end

  it 'allows to set global renderer' do
    TTY::Table.renderer = unicode_renderer
    table = TTY::Table.new
    table.renderer.should be_kind_of(unicode_renderer)
  end

  it 'delegates to renderer' do
    table = TTY::Table.new [['a']]
    table.render(table).should == 'a'
  end
end
