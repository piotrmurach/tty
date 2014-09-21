# encoding: utf-8

require 'spec_helper'

describe TTY::System::Editor, '#executables' do
  let(:object) { described_class }

  subject { object.executables }

  it { is_expected.to be_an Array }

  it { is_expected.to include('vi') }
end
