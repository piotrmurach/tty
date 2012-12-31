# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Text, '#truncate' do
  let(:text) { 'ラドクリフ、マラソン五輪代表に1万m出場にも含み' }
  let(:length) { 12 }

  subject { described_class.truncate(text, :length => length) }

  it { should == "ラドクリフ、マラソン五…" }

end # truncate
