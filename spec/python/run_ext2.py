#!/usr/bin/env python

import os
from timeit import default_timer as timer
from ext2 import Ext2

t1 = timer()

r = Ext2.from_file("%s/ext2.dat" % os.environ['DATA_DIR'])

t2 = timer()

def calc_dir(dir):
    sum = 0
    for entry in dir.entries:
        if entry.name == '.' or entry.name == '..':
            continue
        if entry.file_type == Ext2.DirEntry.FileType.dir:
            sum += calc_dir(entry.inode.as_dir)
        elif entry.file_type == Ext2.DirEntry.FileType.reg_file:
            sum += entry.inode.size
    return sum

calc_dir(r.root_dir)

t3 = timer()

print("parsing: %s seconds" % (t2-t1,))
print("processing: %s seconds" % (t3-t2,))
