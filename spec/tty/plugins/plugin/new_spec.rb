# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Plugin, '#new' do
  let(:gem) { Gem::Specification.new('tty-console', '3.1.3')}
  let(:name) { 'console'}

  subject { described_class.new(name, gem) }

  its(:name) { should == name }

  its(:gem) { should == gem }

  its(:enabled) { should be_false }

  its(:gem_name) { should == "tty-#{name}" }
end
