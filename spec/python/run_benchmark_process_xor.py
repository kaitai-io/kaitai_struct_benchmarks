#!/usr/bin/env python

import os
from timeit import default_timer as timer
from benchmark_process_xor import BenchmarkProcessXor

t1 = timer()

r = BenchmarkProcessXor.from_file("%s/benchmark_process_xor.dat" % os.environ['DATA_DIR'])

t2 = timer()

sum = 0
for chunk in r.chunks:
    for n in chunk.body.numbers:
        sum += n

t3 = timer()

print("parsing: %s seconds" % (t2-t1,))
print("processing: %s seconds" % (t3-t2,))
