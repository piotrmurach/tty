# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Logger, '#new' do
  let(:object) { described_class }
  let(:output) { StringIO.new }

  subject { object.new options }

  context 'when default' do
    let(:options) { {:namespace => ''} }

    its(:level) { should eql object::ALL }

    its(:output) { should eql $stderr }

    its(:timestamp_format) { should eql '%Y-%m-%d %T' }
  end

  context 'when custom' do
    let(:options) { {
      :namespace => 'tty::color',
      :level => 2,
      :output => output,
      :timestamp_format => "%dd" } }

    its(:namespace) { should eql 'tty::color' }

    its(:level) { should eql 2 }

    its(:output) { should eql output }

    its(:timestamp_format) { should eql '%dd' }
  end
end
