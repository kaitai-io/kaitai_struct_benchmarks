#!/usr/bin/env python

import os
from timeit import default_timer as timer
from benchmark_process_xor import BenchmarkProcessXor

maxnum = 0

t1 = timer()

r = BenchmarkProcessXor.from_file("%s/benchmark_process_xor.dat" % os.environ['DATA_DIR'])

t2 = timer()

for chunk in r.chunks:
    tm = max(chunk.body.numbers)
    maxnum = max(tm, maxnum)

t3 = timer()

print("max = %d" % maxnum)
print(t2 - t1)
print(t3 - t2)
