# encoding: utf-8

Gem::Specification.new do |spec|
  spec.name     = 'foo'
  spec.version  = '0.0.1'
  spec.platform = 'ruby'
  spec.require_paths = ['lib']
  spec.summary = 'A foo gem'

  spec.add_dependency 'pastel'
  spec.add_dependency 'equatable'
  spec.add_dependency 'tty-command', '~> 0.3.0'
  spec.add_dependency 'tty-prompt',  '~> 0.10.0'
  spec.add_dependency 'tty-spinner', '~> 0.4.0'

  spec.add_development_dependency 'rake'
end
