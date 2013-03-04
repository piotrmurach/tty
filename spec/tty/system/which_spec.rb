
require 'spec_helper'

describe TTY::System::Which, '#which' do
  let(:path) { "/usr/local/bin:/usr/local/git/bin" }
  let(:extension) { '.bat' }

  context 'without extension' do
    before {
      ENV.stub(:[]).with('PATHEXT').and_return(nil)
      ENV.stub(:[]).with('PATH').and_return(path)
    }

    it 'finds command' do
      File.stub(:executable?) { true }
      expect(subject.which("ruby")).to eql "/usr/local/bin/ruby"
    end

    it "doesn't find command" do
      File.stub(:executable?) { false }
      expect(subject.which("ruby")).to be_nil
    end
  end

  context 'with extension' do
    before {
      ENV.stub(:[]).with('PATHEXT').and_return(extension)
      ENV.stub(:[]).with('PATH').and_return(path)
    }

    it 'finds command' do
      File.stub(:executable?) { true }
      expect(subject.which("ruby")).to eql "/usr/local/bin/ruby.bat"
    end

    it "doesn't find command" do
      File.stub(:executable?) { false }
      expect(subject.which("ruby")).to be_nil
    end
  end
end
