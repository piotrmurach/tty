# frozen_string_literal: true

require 'tty/gemspec'

RSpec.describe TTY::Gemspec, '#read' do
  it "reads gemspec's content" do
    gemspec_path = fixtures_path('foo-0.0.1.gemspec')
    gemspec = TTY::Gemspec.new
    gemspec.read(gemspec_path)

    expect(gemspec.content).to eq(::File.binread(gemspec_path))
    expect(gemspec.var_name).to eq('spec')

    expect(gemspec.pre_var_indent).to eq(2)
    expect(gemspec.post_var_indent).to eq(15)
  end
end
