# -*- encoding: utf-8 -*-
$:.unshift File.expand_path('../lib', __FILE__)
require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

FileList['tasks/**/*.rake'].each { |task| import task }

task :default => [:spec]
