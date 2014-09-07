# encoding: utf-8

require 'spec_helper'

describe TTY::System::Which, '#which' do
  let(:path) { "/usr/local/bin:/usr/local/git/bin" }
  let(:extension) { '.bat' }

  subject { described_class.new(command) }

  context 'without extension' do
    let(:command)  { 'ruby' }

    before {
      allow(ENV).to receive(:[]).with('PATHEXT').and_return(nil)
      allow(ENV).to receive(:[]).with('PATH').and_return(path)
    }

    it 'finds command' do
      allow(File).to receive(:executable?) { true }
      expect(subject.which).to eql "/usr/local/bin/ruby"
    end

    it "doesn't find command" do
      allow(File).to receive(:executable?) { false }
      expect(subject.which).to be_nil
    end
  end

  context 'with extension' do
    let(:command) { 'ruby' }

    before {
      allow(ENV).to receive(:[]).with('PATHEXT').and_return(extension)
      allow(ENV).to receive(:[]).with('PATH').and_return(path)
    }

    it 'finds command' do
      allow(File).to receive(:executable?) { true }
      expect(subject.which).to eql "/usr/local/bin/ruby.bat"
    end

    it "doesn't find command" do
      allow(File).to receive(:executable?) { false }
      expect(subject.which).to be_nil
    end
  end
end
