# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tty/version'

Gem::Specification.new do |spec|
  spec.name          = "tty"
  spec.platform      = Gem::Platform::RUBY
  spec.version       = TTY::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = [""]
  spec.description   = %q{A toolbox for developing beautiful command line clients.}
  spec.summary       = %q{A toolbox for developing beautiful command line clients in Ruby with a fluid interface for gathering input, querying terminal properties and displaying information.}
  spec.homepage      = 'https://piotrmurach.github.io/tty/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.bindir        = "exe"
  spec.executables   = ['teletype']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'tty-color',       '~> 0.4.2'
  spec.add_dependency 'tty-cursor',      '~> 0.5.0'
  spec.add_dependency 'tty-command',     '~> 0.7.0'
  spec.add_dependency 'tty-editor',      '~> 0.3.0'
  spec.add_dependency 'tty-file',        '~> 0.5.0'
  spec.add_dependency 'tty-pager',       '~> 0.11.0'
  spec.add_dependency 'tty-platform',    '~> 0.1.0'
  spec.add_dependency 'tty-progressbar', '~> 0.13.0'
  spec.add_dependency 'tty-prompt',      '~> 0.14.0'
  spec.add_dependency 'tty-screen',      '~> 0.6.4'
  spec.add_dependency 'tty-spinner',     '~> 0.8.0'
  spec.add_dependency 'tty-table',       '~> 0.10.0'
  spec.add_dependency 'tty-tree',        '~> 0.1.0'
  spec.add_dependency 'tty-which',       '~> 0.3.0'
  spec.add_dependency 'equatable',       '~> 0.5.0'
  spec.add_dependency 'pastel',          '~> 0.7.2'

  spec.add_dependency 'thor',    '~> 0.19.4'
  spec.add_dependency 'bundler', '~> 1.16', '< 2.0'

  spec.add_development_dependency 'rspec', "~> 3.0"
  spec.add_development_dependency 'rake'
end
