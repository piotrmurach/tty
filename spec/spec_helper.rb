require 'rubygems'

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
