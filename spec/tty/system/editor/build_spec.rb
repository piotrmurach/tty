# encoding: utf-8

require 'spec_helper'

describe TTY::System::Editor, '#build' do
  let(:file) { "/users/piotr/hello world.rb" }
  let(:name) { "vim" }
  let(:object) { described_class }

  subject(:editor) { object.new(file) }

  before { allow(object).to receive(:command).and_return(name) }

  context 'when on windows' do
    before {
      allow(TTY::System).to receive(:unix?).and_return(false)
      allow(TTY::System).to receive(:windows?).and_return(true)
    }

    it "doesn't shell escape" do
      expect(subject.build).to eql("vim \\users\\piotr\\hello world.rb")
    end
  end

  context 'when on unix' do
    before { allow(TTY::System).to receive(:unix?).and_return(true) }

    it 'escapes shell' do
      expect(editor.build).to eql("vim /users/piotr/hello\\ world.rb")
    end
  end
end
