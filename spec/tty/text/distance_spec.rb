# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Text, '#distance' do
  let(:strings) { ['witch', 'which'] }

  subject { described_class.distance(*strings) }

  it { should == 2 }
end # distance
