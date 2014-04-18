# encoding: utf-8

begin
  require 'reek/rake/task'

  namespace :metrics do
    Reek::Rake::Task.new do |t|
      t.fail_on_error = false
    end
  end
rescue LoadError
  warn "Reek is not available. In order to run reek, you must: gem install reek"
end
