# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::System::Editor, '#executables' do
  let(:object) { described_class }

  subject { object.executables }

  it { should be_an Array }

  it { should include('vi') }
end
