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

require 'rubygems'
require 'tty'

module Helpers
  def tmp_path(filename = nil)
    File.join(File.dirname(__FILE__), '../tmp', filename.to_s)
  end

  def fixtures_dir
    File.join(File.dirname(__FILE__), 'fixtures')
  end

  def fixtures_path(filename = nil)
    File.join(File.dirname(__FILE__), 'fixtures', filename.to_s)
  end
end

RSpec.configure do |config|
  config.include(Helpers)
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.raise_errors_for_deprecations!
end

class String
  def unindent
    gsub(/^[ \t]*/, '').chomp
  end
end
