# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Renderer, '#pick_renderer' do
  let(:klass) { ::Class.new }
  let(:instance) { klass.new }

  subject { instance.pick_renderer renderer}

  before { klass.send :include, described_class }

  context 'with basic' do
    let(:renderer) { :basic }

    it { should be_instance_of(TTY::Table::Renderer::Basic) }
  end

  context 'with unicode' do
    let(:renderer) { :unicode }

    it { should be_instance_of(TTY::Table::Renderer::Unicode) }
  end

end
