# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Terminal, '#home' do

  before { ENV.stub!(:[]) }

  subject(:terminal) { described_class.new.home }

  after { terminal.instance_variable_set(:@home, nil) }

  it 'expands user home path if HOME environemnt not set' do
    File.should_receive(:expand_path).and_return('/home/user')
    expect(terminal).to eql('/home/user')
  end

  it 'defaults to user HOME environment' do
    ENV.stub!(:[]).with('HOME').and_return('/home/user')
    expect(terminal).to eq('/home/user')
  end

  context 'when failed to expand' do
    before { File.should_receive(:expand_path).and_raise(RuntimeError) }

    it 'returns C:/ on windows' do
      TTY::System.stub(:windows?).and_return true
      expect(terminal).to eql("C:/")
    end

    it 'returns root on unix' do
      TTY::System.stub(:windows?).and_return false
      expect(terminal).to eql("/")
    end
  end

end
