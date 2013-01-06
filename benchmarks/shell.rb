# -*- encoding: utf-8 -*-

# Benchmark speed of shell operations

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'tty'
require 'benchmark'
require 'benchmark/ips'
require 'stringio'

input  = ::StringIO.new
output = ::StringIO.new
shell  = TTY::Shell.new(input, output)

Benchmark.ips do |r|

  r.report("Ruby #puts") do
    output.puts "What is your name?"
  end

  r.report("TTY #ask") do
    shell.ask("What is your name?")
  end

end
