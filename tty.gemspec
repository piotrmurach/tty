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

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'benchmark_suite'
end
