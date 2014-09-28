# encoding: utf-8

require 'spec_helper'

describe TTY::Conversion::BooleanConverter, '#convert' do
  let(:object) { described_class.new }

  subject(:converter) { object.convert(value) }

  context "with empty" do
    let(:value) { '' }

    it { expect { subject }.to raise_error(TTY::Conversion::TypeError) }
  end

  context "with true" do
    let(:value) { true }

    it { is_expected.to eq(true) }
  end

  context "with 'true'" do
    let(:value) { 'true' }

    it { is_expected.to eq(true) }
  end

  context "with TRUE" do
    let(:value) { TRUE }

    it { is_expected.to eq(true) }
  end

  context "with 'TRUE'" do
    let(:value) { 'TRUE' }

    it { is_expected.to eq(true) }
  end

  context "with 't'" do
    let(:value) { 't' }

    it { is_expected.to eq(true) }
  end

  context "with 'T'" do
    let(:value) { 'T' }

    it { is_expected.to eq(true) }
  end

  context "with 1" do
    let(:value) { 1 }

    it { is_expected.to eq(true) }
  end

  context "with '1'" do
    let(:value) { '1' }

    it { is_expected.to eq(true) }
  end

  context "with false" do
    let(:value) { false }

    it { is_expected.to eq(false) }
  end

  context "with 'false'" do
    let(:value) { 'false' }

    it { is_expected.to eq(false) }
  end

  context "with FALSE" do
    let(:value) { FALSE }

    it { is_expected.to eq(false) }
  end

  context "with 'FALSE'" do
    let(:value) { 'FALSE' }

    it { is_expected.to eq(false) }
  end

  context "with 'f'" do
    let(:value) { 'f' }

    it { is_expected.to eq(false) }
  end

  context "with 'F'" do
    let(:value) { 'F' }

    it { is_expected.to eq(false) }
  end

  context "with 0" do
    let(:value) { 0 }

    it { is_expected.to eq(false) }
  end

  context "with '0'" do
    let(:value) { '0' }

    it { is_expected.to eq(false) }
  end

  context "with FOO" do
    let(:value) { 'FOO' }

    it { expect { subject }.to raise_error(TTY::Conversion::TypeError) }
  end
end
