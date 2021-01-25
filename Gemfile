source "https://rubygems.org"

gemspec

require "yaml"
tty_gems = YAML.load_file(::File.expand_path("lib/tty/gems.yml", __dir__))

tty_gems.each do |tty_gem|
  gem tty_gem["name"], tty_gem["version"]
end

group :metrics do
  gem "simplecov", "~> 0.16.1"
  gem "yardstick", "~> 0.9.9"
end

group :benchmarks do
  gem "benchmark-ips", "~> 2.7.2"
end
