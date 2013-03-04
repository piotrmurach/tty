# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::System, '#platform' do
  subject { described_class }

  it { should respond_to(:windows?) }

  it { should respond_to(:unix?) }

  it { should respond_to(:which) }

  it 'checks if windows' do
    RbConfig::CONFIG.stub(:[]).with('host_os').and_return 'windows'
    subject.windows?.should be_true
  end

  it 'checks if unix' do
    RbConfig::CONFIG.stub(:[]).with('host_os').and_return 'darwin'
    subject.unix?.should be_true
  end

  it 'delegates to which' do
    command = 'ruby'
    TTY::System::Which.should_receive(:new).with(command)
    subject.which(command)
  end
end
