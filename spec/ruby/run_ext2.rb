#!/usr/bin/env ruby

require 'benchmark'

require 'ext2'

r = nil

t1 = Benchmark::measure {
  r = Ext2::from_file("#{ENV['DATA_DIR']}/ext2.dat")
}

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

t2 = Benchmark::measure {
  p calc_dir(r.root_dir)
}

p t1
p t2
