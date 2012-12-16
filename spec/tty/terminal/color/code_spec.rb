# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Color, '#code' do
  let(:string) { "This is a \e[1m\e[34mbold blue text\e[0m" }

  it 'finds single code' do
    subject.code(:black).should == ["\e[30m"]
  end

  it 'finds more than one code' do
    subject.code(:black, :green).should == ["\e[30m", "\e[32m"]
  end

  it "doesn't find code" do
    expect { subject.code(:unkown) }.to raise_error(NameError)
  end
end
