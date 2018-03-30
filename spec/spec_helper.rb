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

require 'tty'
require 'tty-file'
require 'fileutils'
require 'open3'

class String
  def unindent
    gsub(/^[ \t]*/, '').chomp
  end
end

module TestHelpers
  module Paths
    def gem_root
      File.expand_path("#{File.dirname(__FILE__)}/..")
    end

    def dir_path(*args)
      path = File.join(gem_root, *args)
      FileUtils.mkdir_p(path)
      File.realpath(path)
    end

    def tmp_path(*args)
      File.join(dir_path('tmp'), *args)
    end

    def fixtures_path(*args)
      File.join(dir_path('spec/fixtures'), *args)
    end

    def within_dir(target, &block)
      ::Dir.chdir(target, &block)
    end
  end

  module Silent
    def silent_run(*args)
      out = Tempfile.new('tty-cmd')
      result = system(*args, out: out.path)
      return if result
      out.rewind
      fail "#{args.join} failed:\n#{out.read}"
    end
  end
end

RSpec.configure do |config|
  config.include(TestHelpers::Paths)
  config.include(TestHelpers::Silent)
  config.after(:example, type: :cli) do
    FileUtils.rm_rf(tmp_path)
  end
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = :random
  config.raise_errors_for_deprecations!
  config.disable_monkey_patching!
end
