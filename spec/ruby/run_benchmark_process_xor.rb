#!/usr/bin/env ruby

require 'benchmark_process_xor'
require 'benchmark'

r = nil
max = nil

t1 = Benchmark::measure {
  r = BenchmarkProcessXor::from_file("#{ENV['DATA_DIR']}/benchmark_process_xor.dat")
}

t2 = Benchmark::measure {
  max = r.chunks.map { |chunk| chunk.body.numbers.max }.max
}

puts "max = #{max}"
p t1
p t2
