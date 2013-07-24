# encoding: utf-8

require 'rubygems'

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

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'tty'

RSpec.configure do |config|
  config.order = :rand
end

class String
  def normalize
    gsub(/^[ \t]*/, '').chomp
  end
end

unless defined?(Gem::Specification)
  Gem::Specification = Struct.new(:name, :version)
end
