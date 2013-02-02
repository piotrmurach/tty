# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::BorderOptions, '.new' do

  subject(:options) { described_class.new }

  its(:characters) { should eql({}) }

  its(:separator) { should be_nil }

  its(:style) { should be_nil }

end # new
