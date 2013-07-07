# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer, '#renderer' do
  let(:basic_renderer)   { TTY::Table::Renderer::Basic }
  let(:ascii_renderer)   { TTY::Table::Renderer::ASCII }
  let(:object) { described_class }

  subject { object }

#   before { object.renderer = basic_renderer }
# 
#   after { object.renderer = basic_renderer }

  it { should respond_to(:render) }

#   it 'sets basic renderer' do
#     object.renderer.should be TTY::Table::Renderer::Basic
#   end
# 
#   it 'allows to set ascii instance renderer' do
#     object.renderer = ascii_renderer
#     expect(object.renderer).to be(ascii_renderer)
#   end
end
