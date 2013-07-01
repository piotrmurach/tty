# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::System::Editor, '#available' do
  let(:execs) { ['vi', 'emacs'] }
  let(:editor) { 'sublime' }
  let(:system) { TTY::System }

  subject { described_class }

  before { subject.stub(:executables).and_return(execs) }

  context 'when editor exists' do
    before {
      system.stub(:exists?).with('vi').and_return(true)
      system.stub(:exists?).with('emacs').and_return(false)
    }

    it 'finds single command' do
      expect(subject.available).to eql('vi')
    end
  end

  context 'when no command exists' do
    before { system.stub(:exists?).and_return(false) }

    it "doesn't find command" do
      expect(subject.available).to be_nil
    end
  end

  context 'when custom command' do
    before { system.stub(:exists?).with(editor).and_return(true) }

    it "takes precedence over other commands" do
      expect(subject.available(editor)).to eql(editor)
    end
  end
end
