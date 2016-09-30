package io.kaitai.struct.benchmarks;

import java.io.IOException;

abstract public class Benchmark {
    public abstract String dataName();
    public abstract void testLoad() throws IOException;
    public abstract void testCalc() throws IOException;
    public abstract void consumeResult();

    private String dataFileName;

    public String dataFileName() {
        if (dataFileName == null) {
            dataFileName = System.getenv("DATA_DIR") + "/" + dataName() + ".dat";
        }
        return dataFileName;
    }
}
