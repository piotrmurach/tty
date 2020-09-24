source "https://rubygems.org"

gemspec

require "yaml"
tty_gems = YAML.load_file(::File.expand_path("lib/tty/gems.yml", __dir__))

tty_gems.each do |tty_gem|
  gem tty_gem["name"], tty_gem["version"]
end

gem "tty-command", git: "https://github.com/piotrmurach/tty-command"
gem "tty-pager", git: "https://github.com/piotrmurach/tty-pager"
gem "tty-progressbar", git: "https://github.com/piotrmurach/tty-progressbar"

group :metrics do
  gem "simplecov", "~> 0.16.1"
  gem "yardstick", "~> 0.9.9"
end

group :benchmarks do
  gem "benchmark-ips", "~> 2.7.2"
end
