# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Text::Distance, '#initialize' do
  let(:strings) { ['abc', 'acb'] }

  subject { described_class.new(*strings) }

  its(:first) { should == strings.first }

  its(:second) { should == strings.last }

end # initialize
