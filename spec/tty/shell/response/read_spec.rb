# encoding: utf-8

require 'spec_helper'

describe TTY::Shell::Question, '#read_password' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  context 'with no mask' do
    it 'asks with echo on' do
      input << "password"
      input.rewind
      q = shell.ask("What is your password: ").echo(true)
      expect(q.read).to eql("password")
      expect(output.string).to eql('What is your password: ')
      expect(q.mask?).to eq(false)
    end

    it 'asks with echo off' do
      input << "password"
      input.rewind
      q = shell.ask("What is your password: ").echo(false)
      expect(q.read).to eql("password")
      expect(output.string).to eql('What is your password: ')
      expect(q.mask?).to eq(false)
    end
  end

  context 'with mask' do
    it 'masks output with character' do
      input << "password\n"
      input.rewind
      q = shell.ask("What is your password: ").mask('*')
      expect(q.read).to eql("password")
      expect(output.string).to eql('What is your password: ********')
      expect(q.mask?).to eq(true)
    end

    it 'ignores mask if echo is off' do
      input << "password"
      input.rewind
      q = shell.ask("What is your password: ").echo(false).mask('*')
      expect(q.read).to eql("password")
      expect(output.string).to eql('What is your password: ')
      expect(q.mask?).to eq(true)
    end
  end

  context 'with mask and echo as options' do
    it 'asks with options' do
      input << "password"
      input.rewind
      q = shell.ask("What is your password: ", :echo => false, :mask => '*')
      expect(q.read_password).to eq("password")
    end

    it 'asks with block' do
      input << "password"
      input.rewind
      q = shell.ask "What is your password: " do
        echo  false
        mask '*'
      end
      expect(q.read_password).to eq("password")
    end
  end
end
