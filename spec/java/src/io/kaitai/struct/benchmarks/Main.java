package io.kaitai.struct.benchmarks;

import java.io.IOException;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

public class Main {
    private static final int WARMUP_COUNT = 10;
    private static final int NORMAL_COUNT = WARMUP_COUNT * 3;

    private static Series d1s;
    private static Series d2s;

    private static final Benchmark[] BENCHMARKS = new Benchmark[] {
            new TestBenchmarkProcessXor(),
            new TestExt2(),
            new TestPcap(),
    };

    public static void main(String[] args) throws IOException {
        if (args.length != 1) {
            System.out.println("Usage: benchmarks <benchmark>");
            System.out.println("Available benchmarks:");
            for (Benchmark b : BENCHMARKS)
                System.out.println("- " + b.dataName());
            return;
        }

        Benchmark bm = null;
        for (Benchmark b : BENCHMARKS)
            if (b.dataName().equals(args[0]))
                bm = b;

        if (bm == null) {
            System.out.println("Unknown benchmark");
            return;
        }

        System.out.println("=== Warm-up iterations");
        runBenchs(bm, WARMUP_COUNT);

        System.out.println("=== Normal iterations");
        runBenchs(bm, NORMAL_COUNT);
    }

    public static void runBenchs(Benchmark bm, int count) throws IOException {
        d1s = new Series();
        d2s = new Series();
        for (int i = 0; i < count; i++) {
            runBench(bm);
        }
        report();
    }

    public static void runBench(Benchmark bm) throws IOException {
        long t1 = System.nanoTime();
        bm.testLoad();
        long t2 = System.nanoTime();
        bm.testCalc();
        long t3 = System.nanoTime();
        bm.consumeResult();

        long d1 = t2 - t1;
        long d2 = t3 - t2;

        System.out.println("load: " + d1 + ", calc: " + d2);

        d1s.add(d1);
        d2s.add(d2);
    }

    private static void report() {
        System.out.println("load: " + d1s.report());
        System.out.println("calc: " + d2s.report());
    }

    public static class Series {
        private long count = 0;
        private long sum = 0;
        private long sum2 = 0;

        void add(long x) {
            count += 1;
            sum += x;
            sum2 += x * x;
        }

        public double avg() {
            return ((double) sum) / count;
        }

        public double stDev() {
            return Math.sqrt((count * sum2 - sum * sum) / (count * (count - 1)));
        }

        public String report() {
            DecimalFormat df = new DecimalFormat("0", DecimalFormatSymbols.getInstance(Locale.ENGLISH));
            df.setMaximumFractionDigits(340); //340 = DecimalFormat.DOUBLE_FRACTION_DIGITS
            return df.format(avg() / 1e9) + " ± " + df.format(stDev() / 1e9);
        }
    }
}
