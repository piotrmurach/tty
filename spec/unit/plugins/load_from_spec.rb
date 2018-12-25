# frozen_string_literal: true

RSpec.describe TTY::Plugins, '#load_from' do
  it "loads gems with a specific pattern" do
    plugins = TTY::Plugins.new
    gemspec_path = fixtures_path('foo-0.0.1.gemspec')
    plugins.load_from(gemspec_path, /^tty-(.*)/)

    expect(plugins.to_a.map(&:name)).to eq([
      'tty-command',
      'tty-prompt',
      'tty-spinner'
    ])
  end

  it "allows for complex pattern" do
    plugins = TTY::Plugins.new
    gemspec_path = fixtures_path('foo-0.0.1.gemspec')
    plugins.load_from(gemspec_path, /^tty-(.*)|pastel/)

    expect(plugins.to_a.map(&:name)).to eq([
      'pastel',
      'tty-command',
      'tty-prompt',
      'tty-spinner'
    ])
  end
end
