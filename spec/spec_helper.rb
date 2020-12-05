# frozen_string_literal: true

if ENV["COVERAGE"] == "true"
  require "simplecov"

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
  ]

  SimpleCov.start do
    add_filter "spec"
  end
end

require "tty"
require "tty-file"
require "fileutils"
require "shellwords"
require "tmpdir"
require "open3"

class String
  def unindent
    gsub(/^[ \t]*/, "").chomp
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

    def fixtures_path(*args)
      File.join(dir_path("spec/fixtures"), *args)
    end

    def within_dir(target, &block)
      ::Dir.chdir(target, &block)
    end
  end

  module Silent
    def silent_run(*args)
      out = Tempfile.new("tty-cmd")
      result = system(*args, out: out.path)
      return if result
      out.rewind
      fail "#{args.join} failed:\n#{out.read}"
    end
  end
end

RSpec.shared_context "sandbox" do
  around(:each) do |example|
    ::Dir.mktmpdir do |dir|
      ::FileUtils.cp_r(fixtures_path("/."), dir)
      ::Dir.chdir(dir, &example)
    end
  end
end

RSpec.configure do |config|
  config.include(TestHelpers::Paths)
  config.include(TestHelpers::Silent)
  config.include_context "sandbox", type: :sandbox

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.max_formatted_output_length = nil
  end

  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = :random
  config.raise_errors_for_deprecations!
  config.disable_monkey_patching!
end
