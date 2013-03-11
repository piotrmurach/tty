# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Table::Header, '#call' do
  let(:object) { described_class.new(attributes) }
  let(:attributes) { [:id, :name, :age] }

  subject { object.call(name) }

  context '' do
    let(:name) { :age }

    it { should == 2 }
  end

  context '' do
    let(:name) { :mine }

    specify { expect { subject }.to raise_error(ArgumentError, "the header 'mine' is unknown")}
  end
end
