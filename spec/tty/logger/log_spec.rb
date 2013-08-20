# -*- encoding: utf-8 -*-

require 'spec_helper'
require 'timecop'

describe TTY::Logger, '#log' do
  let(:output)    { StringIO.new }
  let(:message)   { 'text' }
  let(:namespace) { 'tty::'}
  let(:options)   { {output: output, namespace: namespace} }
  let(:object)    { described_class.new(options) }

  subject { object.log(message) }

  before { Timecop.freeze }

  after { Timecop.return }

  it 'logs message to output' do
    subject
    expect(output.string).to eq("#{object.timestamp} - #{message}")
  end
end
