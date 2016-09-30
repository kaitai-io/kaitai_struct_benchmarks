#!/usr/bin/env ruby
# coding: utf-8

require_relative 'helpers'

require 'pcap'

ITERATIONS = 50

t1s = Series.new
t2s = Series.new
fn = "#{ENV['DATA_DIR']}/pcap_http.dat"
num_pkt = nil

ITERATIONS.times { |i|
  r = nil

  t1 = Benchmark::measure {
    r = Pcap::from_file(fn)
  }

  sum = 0
  t2 = Benchmark::measure {
    r.packets.each { |packet|
      eth = packet.ethernet_body
      next if eth.nil?
      ipv4 = eth.ipv4_body
      next if ipv4.nil?
      sum += ipv4.total_length
    }
  }
  p sum

  num_pkt = r.packets.size

  t1s << t1.real
  t2s << t2.real

  printf "load: %f\n", t1.real
  printf "calc: %f\n", t2.real
}

puts "=" * 80
printf "load: %f ± %f\n", t1s.avg, t1s.stdev
printf "calc: %f ± %f\n", t2s.avg, t2s.stdev

printf "packet/s: %d\n", num_pkt / t1s.avg
