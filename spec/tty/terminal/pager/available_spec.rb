# encoding: utf-8

require 'spec_helper'

describe TTY::Terminal::Pager, '#available' do
  let(:execs)   { ['less', 'more'] }
  let(:system)  { TTY::System }
  let(:command) { 'less' }

  subject(:pager) { described_class }

  before { allow(subject).to receive(:executables).and_return(execs) }

  context 'when command exists' do
    before {
      allow(system).to receive(:exists?).with('less').and_return(true)
      allow(system).to receive(:exists?).with('more').and_return(false)
    }

    it 'finds single command' do
      expect(pager.available).to eql('less')
    end
  end

  context 'when no command exists' do
    before { allow(system).to receive(:exists?).and_return(false) }

    it "doesn't find command" do
      expect(pager.available).to be_nil
    end
  end

  context 'when custom command' do
    before { allow(system).to receive(:exists?).with(command).and_return(true) }

    it "takes precedence over other commands" do
      expect(subject.available(command)).to eql(command)
    end
  end
end
