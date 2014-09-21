# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question, '#read_email' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  context 'with valid email' do
    it 'reads empty' do
      input << ""
      input.rewind
      q = shell.ask("What is your email?")
      expect { q.read_email }.to raise_error(TTY::InvalidArgument)
    end

    it 'reads valid email' do
      input << "piotr@example.com"
      input.rewind
      q = shell.ask("What is your email?")
      expect(q.read_email).to eql "piotr@example.com"
    end
  end

  context 'with invalid email' do
    it 'fails to read invalid email' do
      input << "this will@neverwork"
      input.rewind
      q = shell.ask("What is your email?")
      expect { q.read_email }.to raise_error(TTY::InvalidArgument)
    end

    it 'reads invalid and asks again' do
      input << "this will@neverwork\nthis.will@example.com"
      input.rewind
      q = shell.ask("What is your email?").on_error(:retry)
      expect(q.read_email).to eql "this.will@example.com"
      expect(output.string).to eql "What is your email?\nWhat is your email?\n"
    end
  end
end
