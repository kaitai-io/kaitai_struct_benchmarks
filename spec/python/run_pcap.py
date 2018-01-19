#!/usr/bin/env python

import os
from timeit import default_timer as timer
from pcap import Pcap

t1 = timer()

r = Pcap.from_file("%s/pcap_http.dat" % os.environ['DATA_DIR'])

t2 = timer()

sum = 0
for packet in r.packets:
    eth = packet.ethernet_body
    if eth:
        ipv4 = eth.ipv4_body
        if ipv4:
            sum += ipv4.total_length

t3 = timer()

print("parsing: %s seconds" % (t2-t1,))
print("processing: %s seconds" % (t3-t2,))
