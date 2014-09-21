# encoding: utf-8

require 'spec_helper'

describe TTY::System::Editor, '#available' do
  let(:execs)  { ['vi', 'emacs'] }
  let(:name) { 'sublime' }
  let(:system) { TTY::System }

  subject(:editor) { described_class }

  before { allow(editor).to receive(:executables).and_return(execs) }

  context 'when editor exists' do
    before {
      allow(system).to receive(:exists?).with('vi').and_return(true)
      allow(system).to receive(:exists?).with('emacs').and_return(false)
    }

    it 'finds single command' do
      expect(editor.available).to eql('vi')
    end
  end

  context 'when no command exists' do
    before { allow(system).to receive(:exists?).and_return(false) }

    it "doesn't find command" do
      expect(editor.available).to be_nil
    end
  end

  context 'when custom command' do
    before { allow(system).to receive(:exists?).with(name).and_return(true) }

    it "takes precedence over other commands" do
      expect(editor.available(name)).to eql(name)
    end
  end
end
