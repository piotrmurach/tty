# encoding: utf-8

require 'spec_helper'

describe TTY::Logger, '#new' do
  let(:object) { described_class }
  let(:output) { StringIO.new }

  subject(:logger) { object.new(options) }

  context 'when default' do
    let(:options) { {namespace: ''} }

    it { expect(logger.level).to eq(object::ALL) }

    it { expect(logger.output).to eq($stderr) }

    it { expect(logger.timestamp_format).to eq('%Y-%m-%d %T') }
  end

  context 'when custom' do
    let(:options) { {
      namespace: 'tty::color',
      level: 2,
      output: output,
      timestamp_format: "%dd" } }

    it { expect(logger.namespace).to eq('tty::color') }

    it { expect(logger.level).to eq(2) }

    it { expect(logger.output).to eq(output) }

    it { expect(logger.timestamp_format).to eq('%dd') }
  end
end
