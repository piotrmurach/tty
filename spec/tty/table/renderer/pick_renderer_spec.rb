# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer, '#pick_renderer' do
  let(:klass) { ::Class.new }
  let(:instance) { described_class }

  subject { instance.pick_renderer(renderer) }

  context 'with basic' do
    let(:renderer) { :basic }

    it { should be(TTY::Table::Renderer::Basic) }
  end

  context 'with unicode' do
    let(:renderer) { :unicode }

    it { should be(TTY::Table::Renderer::Unicode) }
  end
end
