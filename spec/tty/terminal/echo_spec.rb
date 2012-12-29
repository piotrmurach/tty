# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Terminal, '#echo' do
  let(:instance) { described_class.new }

  subject { instance.echo(&block) }

  context 'without block' do
    let(:block) { }

    it { should be_nil }
  end

  context 'with empty block' do
    let(:block) { lambda { '' } }

    it { should == '' }
  end

end
