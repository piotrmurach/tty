# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TTY::Shell, '#suggest' do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:object) { described_class }
  let(:possible) { ['status', 'stage', 'stash', 'commit', 'branch', 'blame'] }

  subject(:shell) { object.new(input, output) }

  after { output.rewind }

  context 'when few matches' do
    let(:string)   { 'sta' }

    it 'suggests few matches' do
      shell.suggest(string, possible)
      expect(output.string).to eql("Did you mean one of these?\n        stage\n        stash\n")
    end
  end

  context 'when one match' do
    let(:string)   { 'b' }

    it 'suggests a single match' do
      shell.suggest(string, possible)
      expect(output.string).to eql("Did you mean this?\n        blame\n")
    end
  end

  context 'when one match' do
    let(:string)   { 'co' }

    it '' do
      shell.suggest(string, possible)
      expect(output.string).to eql("Did you mean this?\n        commit\n")
    end
  end
end
