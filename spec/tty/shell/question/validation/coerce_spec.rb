# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Shell::Question::Validation, '#coerce' do
  let(:validation) { "^[^\.]+\.[^\.]+" }
  let(:instance) { described_class.new }

  subject { instance.coerce validation }

  it { should be_kind_of Regexp }

  context 'when proc' do
   let(:validation) { lambda { "^[^\.]+\.[^\.]+" } }

    it { should be_kind_of Proc }
  end

  context 'when unkown type' do
    let(:validation) { Object.new }

    it { expect { subject }.to raise_error(TTY::ValidationCoercion) }
  end

end
