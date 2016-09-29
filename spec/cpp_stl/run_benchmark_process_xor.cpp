#include <benchmark_process_xor.h>

#include <fstream>
#include <vector>
#include <iostream>
#include <sys/time.h>

extern struct timeval t1, t2, t3;

void test_benchmark_process_xor() {
    std::ifstream ifs("data/benchmark_process_xor.dat", std::ifstream::binary);
    kaitai::kstream ks(&ifs);

    int32_t max = 0;

    gettimeofday(&t1, NULL);
    benchmark_process_xor_t r(&ks);
    gettimeofday(&t2, NULL);

    for (uint i = 0; i < r.chunks()->size(); i++) {
        auto chunk = r.chunks()->at(i);
        auto numbers = chunk->body()->numbers();
        for (int j = 0; j < numbers->size(); j++) {
            int t = numbers->at(j);
            max = t > max ? t : max;
        }
    }

    gettimeofday(&t3, NULL);

    std::cout << "max = " << max << "\n";
}
