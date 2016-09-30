package io.kaitai.struct.benchmarks;

import io.kaitai.struct.testformats.Ext2;

import java.io.IOException;

public class TestExt2 extends Benchmark {
    private Ext2 r;
    private long sum = 0;

    @Override
    public String dataName() {
        return "ext2";
    }

    @Override
    public void testLoad() throws IOException {
        r = Ext2.fromFile(dataFileName());
    }

    @Override
    public void testCalc() throws IOException {
        sum = calcDir(r.rootDir());
    }

    @Override
    public void consumeResult() {
        System.out.println(sum);
    }

    long calcDir(Ext2.Dir dir) throws IOException {
        long sum = 0;
        for (Ext2.DirEntry entry : dir.entries()) {
            if (entry.name().equals(".") || entry.name().equals(".."))
                continue;
            switch (entry.fileType()) {
                case DIR:
                    sum += calcDir(entry.inode().asDir());
                    break;
                case REG_FILE:
                    sum += entry.inode().size();
                    break;
            }
        }
        return sum;
    }
}
