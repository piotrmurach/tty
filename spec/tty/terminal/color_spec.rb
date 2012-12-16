# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Terminal, '#color' do

  it { should respond_to(:color) }

  its(:color) { should be_kind_of TTY::Terminal::Color}
end
