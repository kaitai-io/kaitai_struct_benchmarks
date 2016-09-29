#!/usr/bin/env ruby

require 'benchmark'

require 'ext2'

ITERATIONS = 30

def calc_dir(dir)
  sum = 0
  dir.entries.each { |entry|
    next if entry.name == '.' or entry.name == '..'
    case entry.file_type
    when :file_type_dir
      sum += calc_dir(entry.inode.as_dir)
    when :file_type_reg_file
      sum += entry.inode.size
    end
  }
  sum
end

t1_sum = 0
t2_sum = 0
fn = "#{ENV['DATA_DIR']}/ext2.dat"

ITERATIONS.times { |i|
  r = nil

  t1 = Benchmark::measure {
    r = Ext2::from_file(fn)
  }

  t2 = Benchmark::measure {
    p calc_dir(r.root_dir)
  }

  t1_sum += t1.real
  t2_sum += t2.real
}

puts "load: #{t1_sum.to_f / ITERATIONS}"
puts "calc: #{t2_sum.to_f / ITERATIONS}"
