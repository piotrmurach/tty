# encoding: utf-8

require 'spec_helper'

describe TTY::Terminal, '#home' do
  subject(:terminal) { described_class.new }

  before { allow(ENV).to receive(:[]) }

  after { terminal.instance_variable_set(:@home, nil) }

  it 'expands user home path if HOME environemnt not set' do
    allow(File).to receive(:expand_path).and_return('/home/user')
    expect(terminal.home).to eql('/home/user')
  end

  it 'defaults to user HOME environment' do
    allow(ENV).to receive(:[]).with('HOME').and_return('/home/user')
    expect(terminal.home).to eq('/home/user')
  end

  context 'when failed to expand' do
    before { allow(File).to receive(:expand_path).and_raise(RuntimeError) }

    it 'returns C:/ on windows' do
      allow(TTY::System).to receive(:windows?).and_return(true)
      expect(terminal.home).to eql("C:/")
    end

    it 'returns root on unix' do
      allow(TTY::System).to receive(:windows?).and_return(false)
      expect(terminal.home).to eql("/")
    end
  end
end
