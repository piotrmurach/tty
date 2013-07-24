# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tty/version'

Gem::Specification.new do |gem|
  gem.name          = "tty"
  gem.version       = TTY::VERSION
  gem.authors       = ["Piotr Murach"]
  gem.email         = [""]
  gem.description   = %q{Toolbox for developing CLI clients}
  gem.summary       = %q{Toolbox for developing CLI clients}
  gem.homepage      = "http://github.com/peter-murach/tty"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'benchmark_suite'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'simplecov', '~> 0.7.1'
  gem.add_development_dependency 'coveralls', '~> 0.6.7'
end
