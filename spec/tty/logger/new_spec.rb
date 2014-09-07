# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Logger, '#new' do
  let(:object) { described_class }
  let(:output) { StringIO.new }

  subject { object.new options }

  context 'when default' do
    let(:options) { {namespace: ''} }

    it { expect(subject.level).to eq(object::ALL) }

    it { expect(subject.output).to eq($stderr) }

    it { expect(subject.timestamp_format).to eq('%Y-%m-%d %T') }
  end

  context 'when custom' do
    let(:options) { {
      namespace: 'tty::color',
      level: 2,
      output: output,
      timestamp_format: "%dd" } }

    it { expect(subject.namespace).to eq('tty::color') }

    it { expect(subject.level).to eq(2) }

    it { expect(subject.output).to eq(output) }

    it { expect(subject.timestamp_format).to eq('%dd') }
  end
end
