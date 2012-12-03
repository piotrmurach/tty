# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Shell::Question, '#ask' do

  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:shell) { TTY::Shell.new(input, output) }

  context 'with default' do
    it 'uses default value' do
      name = 'Anonymous'
      q = shell.ask("What is your name?").default(name)
      answer = q.read
      expect(answer).to eql name
    end

    it 'uses default value in block' do
      name = 'Anonymous'
      q = shell.ask "What is your name?" do
        default name
      end
      answer = q.read
      expect(answer).to eql name
    end
  end

  context 'with option' do
    it 'requires value to be present' do
      input << ''
      input.rewind
      q = shell.ask("What is your name?").option(:required)
      expect { q.read }.to raise_error(ArgumentError)
    end
  end

  context 'with type' do
    it 'reads string' do
      name = "Piotr"
      input << name
      input.rewind
      q = shell.ask("What is your name?")
      answer = q.read_string
      expect(answer).to eql name
    end

    it 'reads integer' do
      input << 5
      input.rewind
      q = shell.ask("What temperature?")
      answer = q.read_int
      expect(answer).to eql 5
    end

    it 'reads float' do
      input << '6.0'
      input.rewind
      q = shell.ask("How tall are you?")
      answer = q.read_float
      expect(answer).to eql 6.0
    end

    it 'reads negative boolean' do
      input << 'No'
      input.rewind
      q = shell.ask("Do you read books?")
      answer = q.read_bool
      expect(answer).to eql false
    end

    it 'reads positive boolean' do
      input << 'YES'
      input.rewind
      q = shell.ask("Do you read books?")
      answer = q.read_bool
      expect(answer).to eql true
    end

    it 'reads choice string' do
      input << 'blue'
      input.rewind
      q = shell.ask("Do you read books?")
      answer = q.read_choice :string, ["red", "blue", "black"]
      expect(answer).to eql 'blue'
    end


  end

end
