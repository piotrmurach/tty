# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Terminal, '#size' do
  let(:default_width)  { 80 }
  let(:default_height) { 24 }

  it { should be_instance_of(described_class) }

  it { should respond_to(:width) }

  it { should respond_to(:height) }

  its(:default_width) { should == default_width }

  its(:default_height) { should == default_height }

  context '#width' do
    it 'sets the env variable' do
      ENV.stub(:[]).with('TTY_COLUMNS').and_return '100'
      subject.width.should == 100
    end

    it 'is not unix system' do
      TTY::System.stub(:unix?) { false }
      subject.should_receive(:default_width)
      subject.width
    end

    it 'is unix system' do
      TTY::System.stub(:unix?) { true }
      subject.should_receive(:dynamic_width)
      subject.width
    end

    it 'cannot determine width' do
      ENV.stub(:[]) { raise }
      subject.should_receive(:default_width)
      subject.width
    end
  end

  context '#height' do
    it 'sets the env variable' do
      ENV.stub(:[]).with('TTY_LINES').and_return '50'
      subject.height.should == 50
    end

    it 'is not unix system' do
      TTY::System.stub(:unix?) { false }
      subject.should_receive(:default_height)
      subject.height
    end

    it 'is unix system' do
      TTY::System.stub(:unix?) { true }
      subject.should_receive(:dynamic_height)
      subject.height
    end

    it 'cannot determine width' do
      ENV.stub(:[]) { raise }
      subject.should_receive(:default_height)
      subject.height
    end
  end

  context '#dynamic_width' do
    it 'uses stty' do
      subject.should_receive(:dynamic_width_stty) { 100 }
      subject.dynamic_width
    end

    it 'uses tput' do
      subject.stub(:dynamic_width_stty).and_return 0
      subject.should_receive(:dynamic_width_tput) { 100 }
      subject.dynamic_width
    end
  end

  context '#dynamic_height' do
    it 'uses stty' do
      subject.should_receive(:dynamic_height_stty) { 100 }
      subject.dynamic_height
    end

    it 'uses tput' do
      subject.stub(:dynamic_height_stty).and_return 0
      subject.should_receive(:dynamic_height_tput) { 100 }
      subject.dynamic_height
    end
  end
end
