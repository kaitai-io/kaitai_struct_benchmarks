#include <pcap.h>

#include <fstream>
#include <vector>
#include <iostream>
#include <sys/time.h>
#include <cstddef>

long pcap_calc_sum(pcap_t* pcap) {
    long sum = 0;

    for (uint i = 0; i < pcap->packets()->size(); i++) {
        auto packet = pcap->packets()->operator[](i);
        auto eth = packet->ethernet_body();
        if (eth == NULL)
            continue;
        auto ipv4 = eth->ipv4_body();
        if (ipv4 == NULL)
            continue;
        sum += ipv4->total_length();
    }
    return sum;
}

extern struct timeval t1, t2, t3;

void test_pcap() {
    std::ifstream ifs("data/pcap_http.dat", std::ifstream::binary);
    kaitai::kstream ks(&ifs);

    gettimeofday(&t1, NULL);
    pcap_t r(&ks);
    gettimeofday(&t2, NULL);
    long sum = pcap_calc_sum(&r);
    gettimeofday(&t3, NULL);

    std::cout << "sum = " << sum << std::endl;
}
