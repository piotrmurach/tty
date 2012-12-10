# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Color, '#remove' do
  let(:string) { "This is a \e[1m\e[34mbold blue text\e[0m" }

  it 'remove color from string' do
    subject.remove(string).should == "This is a bold blue text"
  end

end
