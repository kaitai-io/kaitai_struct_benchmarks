package io.kaitai.struct.benchmarks;

import io.kaitai.struct.testformats.BenchmarkProcessXor;

import java.io.IOException;

public class TestBenchmarkProcessXor extends Benchmark {
    private BenchmarkProcessXor r;
    private long max = 0;

    @Override
    public String dataName() {
        return "benchmark_process_xor";
    }

    @Override
    public void testLoad() throws IOException {
        r = BenchmarkProcessXor.fromFile(dataFileName());
    }

    @Override
    public void testCalc() throws IOException {
        for (BenchmarkProcessXor.Chunk chunk : r.chunks()) {
            for (int n : chunk.body().numbers()) {
                max = n > max ? n : max;
            }
        }
    }

    @Override
    public void consumeResult() {
        System.out.println("max = " + max);
    }
}
