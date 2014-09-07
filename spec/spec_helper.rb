# encoding: utf-8

if ENV['TRAVIS'] || ENV['COVERAGE']
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
    add_filter 'spec'
  end
end

require 'tty'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.raise_errors_for_deprecations!
end

class String
  def normalize
    gsub(/^[ \t]*/, '').chomp
  end
end
