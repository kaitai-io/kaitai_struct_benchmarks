package io.kaitai.struct.benchmarks;

import io.kaitai.struct.testformats.Pcap;

import java.io.IOException;

public class TestPcap extends Benchmark {
    Pcap r;
    long sum = 0;

    @Override
    public String dataName() {
        return "pcap_http";
    }

    @Override
    public void testLoad() throws IOException {
        r = Pcap.fromFile(dataFileName());
    }

    @Override
    public void testCalc() throws IOException {
        for (Pcap.Packet packet : r.packets()) {
            Pcap.EthernetFrame eth = packet.ethernetBody();
            if (eth != null) {
                Pcap.Ipv4Packet ipv4 = eth.ipv4Body();
                if (ipv4 != null)
                    sum += ipv4.totalLength();
            }
        }
    }

    @Override
    public void consumeResult() {
        System.out.println(sum);
    }
}
