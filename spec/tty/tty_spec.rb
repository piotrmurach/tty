# encoding: utf-8

require 'spec_helper'

describe TTY do
  let(:object) { described_class }

  it { expect(object.plugins).to be_instance_of(TTY::Plugins) }

  context 'when module' do
    it 'decorates class' do
      klass = Class.new { include TTY }
      expect(klass).to respond_to(:plugins)
    end
  end
end # TTY
