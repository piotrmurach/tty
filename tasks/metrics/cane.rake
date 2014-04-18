# encoding: utf-8

begin
  require 'cane/rake_task'

  namespace :metrics do
    Cane::RakeTask.new do |cane|
      cane.abc_max = 10
      cane.no_style = true
    end
  end
rescue LoadError
  warn "Cane is not available. In order to run cane, you must: gem install cane"
end
