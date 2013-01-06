# -*- encoding: utf-8 -*-

# Benchmark speed of table operations

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'tty'
require 'benchmark'
require 'benchmark/ips'

header        = [:name, :color]
rows          = (1..100).map { |n| ["row#{n}", "red"] }
table         = TTY::Table.new(header, rows)
table_ascii   = TTY::Table.new(header, rows, :renderer => :ascii)
table_unicode = TTY::Table.new(header, rows, :renderer => :unicode)

Benchmark.ips do |r|

  r.report("Ruby #to_s") do
    rows.to_s
  end

  r.report("TTY #to_s") do
    table.to_s
  end

  r.report("TTY ASCII #to_s") do
    table_ascii.to_s
  end

  r.report("TTY Unicode #to_s") do
    table_unicode.to_s
  end

end
