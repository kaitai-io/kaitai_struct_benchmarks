#!/usr/bin/env python

import os
from timeit import default_timer as timer
from pcap import Pcap

fn = "%s/pcap_http.dat" % os.environ['DATA_DIR']

sum = 0

t1 = timer()

r = Pcap.from_file(fn)

t2 = timer()

for packet in r.packets:
    eth = packet.ethernet_body
    if eth:
        ipv4 = eth.ipv4_body
        if ipv4:
            sum += ipv4.total_length

t3 = timer()

print("sum = %d" % sum)
print(t2 - t1)
print(t3 - t2)
