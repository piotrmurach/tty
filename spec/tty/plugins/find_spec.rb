# encoding: utf-8

require 'spec_helper'

describe TTY::Plugins, '#find' do
  it "finds gems with a specific prefix" do
    plugins = TTY::Plugins.new
    spec = Gem::Specification.load fixtures_path('foo-0.0.1.gemspec')
    allow(Gem::Specification).to receive(:find_by_name).with('tty').
      and_return(spec)

    plugins.find('tty')

    expect(plugins.to_a.map(&:name)).to eq([
      'tty-command',
      'tty-prompt',
      'tty-spinner'
    ])
  end
end
