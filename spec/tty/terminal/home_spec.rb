# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Terminal, '#home' do

  before { ENV.stub!(:[]) }

  subject { described_class.new.home }

  after { subject.instance_variable_set(:@home, nil) }

  it { should eq(File.expand_path("~")) }

  it 'defaults to user HOME environment' do
    ENV.stub!(:[]).with('HOME').and_return('/home/user')
    expect(subject).to eq('/home/user')
  end

  context 'when failed to expand' do
    before { File.should_receive(:expand_path).and_raise(RuntimeError) }

    it 'returns C:/ on windows' do
      TTY::System.stub(:windows?).and_return true
      expect(subject).to eql("C:/")
    end

    it 'returns root on unix' do
      TTY::System.stub(:windows?).and_return false
      expect(subject).to eql("/")
    end
  end

end
