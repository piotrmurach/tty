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

  context 'with argument' do
    it 'requires value to be present' do
      input << ''
      input.rewind
      q = shell.ask("What is your name?").argument(:required)
      expect { q.read }.to raise_error(ArgumentError)
    end
  end

  context 'with validation' do
    it 'fails to validate input' do
      input << 'piotrmurach'
      input.rewind
      q = shell.ask("What is your username?").validate(/^[^\.]+\.[^\.]+/)
      expect { q.read_string }.to raise_error(ArgumentError)
    end

    it 'validates input with regex' do
      input << 'piotr.murach'
      input.rewind
      q = shell.ask("What is your username?").validate(/^[^\.]+\.[^\.]+/)
      expect(q.read_string).to eql 'piotr.murach'
    end

    it 'validates input in block' do
      input << 'piotr.murach'
      input.rewind
      q = shell.ask("What is your username?").validate { |arg| arg =~ /^[^\.]+\.[^\.]+/ }
      expect(q.read_string).to eql 'piotr.murach'
    end
  end

  context 'with valid choice' do
    let(:cards) { %w[ club diamond spade heart ] }

    it 'reads valid option' do
      input << 'club'
      input.rewind
      q = shell.ask("What is your card suit sir?").valid(cards)
      answer = q.read_choice
    end

    it 'reads invalid option' do
      input << 'clover'
      input.rewind
      q = shell.ask("What is your card suit sir?").valid(cards)
      expect { q.read_choice }.to raise_error(TTY::InvalidArgument)
    end

    it 'needs argument' do
      input << ''
      input.rewind
      q = shell.ask("What is your card suit sir?").valid(cards)
      expect { q.read_choice }.to raise_error(TTY::ArgumentRequired)
    end

    it 'reads with default' do
      input << ''
      input.rewind
      q = shell.ask("What is your card suit sir?").valid(cards).default('club')
      expect(q.read_choice).to eql 'club'
    end
  end

  context 'with modification' do
    it 'converts to upper case' do
      input << 'piotr'
      input.rewind
      q = shell.ask("What is your name?").modify(:uppercase)
      expect(q.read_string).to eql 'PIOTR'
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

    it 'fails to read boolean' do
      input << 'invalid'
      input.rewind
      q = shell.ask("Do you read books?")
      expect { q.read_bool }.to raise_error(ArgumentError)
    end

    it 'reads negative boolean' do
      input << 'No'
      input.rewind
      q = shell.ask("Do you read books?")
      answer = q.read_bool
      expect(answer).to eql false
    end

    it 'reads positive boolean' do
      input << 'Yes'
      input.rewind
      q = shell.ask("Do you read books?")
      answer = q.read_bool
      expect(answer).to eql true
    end

  end
end
