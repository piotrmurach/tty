# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::System, '#which' do
  let(:command) { 'ruby' }
  let(:which)   { double(:which, :which => command) }

  subject { described_class }

  it 'seeks system command' do
    TTY::System::Which.should_receive(:new).with(command).and_return(which)
    expect(subject.which(command)).to eql(command)
  end
end
