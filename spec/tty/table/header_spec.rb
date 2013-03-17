# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table, '#header' do

  let(:header) { [:header1, :header2] }
  let(:rows)   { [['a1', 'a2'], ['b1', 'b2']] }
  let(:object) { described_class }

  subject { object.new header, rows }

  its(:header) { should be_instance_of TTY::Table::Header }
end
