lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tty/version"

Gem::Specification.new do |spec|
  spec.name          = "tty"
  spec.platform      = Gem::Platform::RUBY
  spec.version       = TTY::VERSION
  spec.authors       = ["Piotr Murach"]
  spec.email         = ["me@piotrmurach.com"]
  spec.description   = %q{A toolbox for developing beautiful command line clients.}
  spec.summary       = %q{A toolbox for developing beautiful command line clients in Ruby with a fluid interface for gathering input, querying terminal properties and displaying information.}
  spec.homepage      = "https://piotrmurach.github.io/tty/"
  spec.license       = "MIT"

  manifest_path      = File.expand_path("tty.manifest", __dir__)
  spec.files         = Dir[*File.read(manifest_path).split]
  spec.bindir        = "exe"
  spec.executables   = ["teletype"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.3.0"

  # spec.add_dependency "tty-box",         "~> 0.5.0"
  # spec.add_dependency "tty-color",       "~> 0.5"
  # spec.add_dependency "tty-command",     "~> 0.9.0"
  # spec.add_dependency "tty-config",      "~> 0.3.2"
  # spec.add_dependency "tty-cursor",      "~> 0.7"
  # spec.add_dependency "tty-editor",      "~> 0.5"
  # spec.add_dependency "tty-file",        "~> 0.8.0"
  # spec.add_dependency "tty-font",        "~> 0.4.0"
  # spec.add_dependency "tty-logger",      "~> 0.2.0"
  # spec.add_dependency "tty-markdown",    "~> 0.6.0"
  # spec.add_dependency "tty-pager",       "~> 0.12"
  # spec.add_dependency "tty-pie",         "~> 0.3.0"
  # spec.add_dependency "tty-platform",    "~> 0.2"
  # spec.add_dependency "tty-progressbar", "~> 0.17"
  # spec.add_dependency "tty-prompt",      "~> 0.20"
  # spec.add_dependency "tty-screen",      "~> 0.7"
  # spec.add_dependency "tty-spinner",     "~> 0.9"
  # spec.add_dependency "tty-table",       "~> 0.11.0"
  # spec.add_dependency "tty-tree",        "~> 0.3"
  # spec.add_dependency "tty-which",       "~> 0.4"
  # spec.add_dependency "pastel",          "~> 0.7.2"

  spec.add_dependency "thor", "~> 0.20.0"
  spec.add_dependency "bundler", "~> 2.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0"
  spec.add_development_dependency "timecop", "~> 0.9"
end
