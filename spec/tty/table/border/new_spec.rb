# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Border, '#new' do
  subject { klass.new }

  context '' do
    let(:klass) { described_class }

    specify { expect {subject }.to raise_error(NotImplementedError) }
  end

  context '' do
    let(:klass) { Class.new }

    specify { expect {subject }.to_not raise_error(NotImplementedError) }

    it { should be_instance_of klass }
  end
end
