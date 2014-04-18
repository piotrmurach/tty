# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Reader, '#getc' do
  let(:instance) { described_class.new(shell) }

  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  subject(:reader) { instance.getc mask }

  context 'with mask' do
    let(:mask) { '*'}

    it 'masks characters' do
      input << "password\n"
      input.rewind
      expect(reader).to eql "password"
      expect(output.string).to eql("********")
    end
  end

  context "without mask" do
    let(:mask) { }

    it 'masks characters' do
      input << "password\n"
      input.rewind
      expect(reader).to eql "password"
      expect(output.string).to eql("password")
    end

    it 'deletes characters when backspace pressed' do
      input << "\b\b"
      input.rewind
      expect(reader).to eql ''
      expect(output.string).to eql('')
    end
  end
end
