# encoding: utf-8

$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
begin
  require 'heckle'

  namespace :metrics do
    desc 'Heckle each module and class'
    task :heckle do
      require 'tty'
    end
  end
rescue LoadError
  warn "Heckle is not available."
end
