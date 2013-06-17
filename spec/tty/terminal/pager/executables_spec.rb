# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Terminal::Pager, '#executables' do
  let(:object) { described_class }

  subject { object.executables }

  it { should be_an Array }

  it { should include('less -isr') }
end
