# encoding: utf-8

require 'spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

describe TTY::Delegatable do
  let(:target)      { :test }
  let(:methods)     { [:output] }
  let(:object)      { Class.new(DelegetableSpec::Object)}
  let(:delegatable) { object.new }

  subject { object.delegatable_method target, *methods }

  it 'creates a method #output' do
    expect { subject }.to change { delegatable.respond_to?(:output) }.
      from(false).
      to(true)
  end

  it 'delegates #output to target' do
    subject
    instance = spy(:target_spec)
    allow(TargetSpec::Object).to receive(:new).and_return(instance)

    delegatable.output
    expect(instance).to have_received(:output)
  end
end
