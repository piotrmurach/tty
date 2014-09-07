# encoding: utf-8

require 'spec_helper'

describe TTY::System, '#which' do
  let(:command) { 'ruby' }
  let(:which)   { double(:which, :which => command) }

  subject(:system) { described_class }

  it 'seeks system command' do
    allow(TTY::System::Which).to receive(:new).with(command).and_return(which)
    expect(system.which(command)).to eql(command)
  end
end
