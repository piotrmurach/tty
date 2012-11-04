begin
  require 'flog'

  namespace :metrics do
    desc 'Analyze for code complexity'
    task :flog do

    end
  end

rescue LoadError
  task :flog do
    warn "Flog is not available. In order to run reek, you must: gem install flog"
  end
end
