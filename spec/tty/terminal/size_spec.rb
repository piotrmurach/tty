# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Terminal, '#size' do
  let(:default_width)  { 80 }
  let(:default_height) { 24 }

  it { is_expected.to be_instance_of(described_class) }

  it { is_expected.to respond_to(:width) }

  it { is_expected.to respond_to(:height) }


  subject(:terminal) { described_class.new }

  it { expect(terminal.default_width).to eq(default_width) }

  it { expect(subject.default_height).to eq(default_height) }

  context '#width' do
    it 'reads the env variable' do
      allow(ENV).to receive(:[]).with('TTY_COLUMNS').and_return('100')
      expect(subject.width).to eq(100)
    end

    it 'is not unix system' do
      allow(TTY::System).to receive(:unix?) { false }
      expect(subject).to receive(:default_width)
      subject.width
    end

    it 'is unix system' do
      allow(TTY::System).to receive(:unix?) { true }
      expect(subject).to receive(:dynamic_width) { default_width }
      expect(subject.width).to eq(80)
    end

    it 'cannot determine width' do
      allow(ENV).to receive(:[]) { raise }
      expect(terminal).to receive(:default_width) { default_width }
      expect(terminal.width).to eq(default_width)
    end
  end

  context '#height' do
    it 'sets the env variable' do
      allow(ENV).to receive(:[]).with('TTY_LINES').and_return('50')
      expect(subject.height).to eq(50)
    end

    it 'is not unix system' do
      allow(TTY::System).to receive(:unix?) { false }
      expect(subject).to receive(:default_height) { default_height }
      expect(subject.height).to eq(default_height)
    end

    it 'is unix system' do
      allow(TTY::System).to receive(:unix?) { true }
      expect(subject).to receive(:dynamic_height) { default_height }
      expect(subject.height).to eq(default_height)
    end

    it 'cannot determine width' do
      allow(ENV).to receive(:[]) { raise }
      expect(subject).to receive(:default_height)
      subject.height
    end
  end

  context '#dynamic_width' do
    it 'uses stty' do
      expect(subject).to receive(:dynamic_width_stty) { 100 }
      expect(subject.dynamic_width).to eq(100)
    end

    it 'uses tput' do
      allow(subject).to receive(:dynamic_width_stty).and_return(0)
      expect(subject).to receive(:dynamic_width_tput) { 100 }
      expect(subject.dynamic_width).to eq(100)
    end
  end

  context '#dynamic_height' do
    it 'uses stty' do
      allow(subject).to receive(:dynamic_height_stty) { 100 }
      expect(subject.dynamic_height).to eq(100)
    end

    it 'uses tput' do
      allow(subject).to receive(:dynamic_height_stty).and_return(0)
      expect(subject).to receive(:dynamic_height_tput) { 100 }
      expect(subject.dynamic_height).to eq(100)
    end
  end
end
