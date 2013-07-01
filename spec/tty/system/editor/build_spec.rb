# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::System::Editor, '#build' do
  let(:file) { "/users/piotr/hello world.rb" }
  let(:editor) { "vim" }
  let(:object) { described_class }

  subject { object.new(file) }

  before { object.stub(:editor).and_return(editor) }

  context 'when on windows' do
    before {
      TTY::System.stub(:unix?).and_return(false)
      TTY::System.stub(:windows?).and_return(true)
    }

    after {
      TTY::System.unstub(:unix?)
      TTY::System.unstub(:windows?)
    }

    it "doesn't shell escape" do
      expect(subject.build).to eql("vim \\users\\piotr\\hello world.rb")
    end
  end

  context 'when on unix' do

    before { TTY::System.stub(:unix?).and_return(true) }

    after  { TTY::System.unstub(:unix?) }

    it 'escapes shell' do
      expect(subject.build).to eql("vim /users/piotr/hello\\ world.rb")
    end
  end
end
