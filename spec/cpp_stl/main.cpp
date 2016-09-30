#include <sys/time.h>

#include <iostream>

void test_benchmark_process_xor();
void test_ext2();
void test_pcap();

struct benchmark_case {
    std::string name;
    void (*test_func)();
};

benchmark_case benchmarks[] = {
    {
        .name = std::string("benchmark_process_xor"),
        .test_func = test_benchmark_process_xor,
    },
    {
        .name = std::string("ext2"),
        .test_func = test_ext2,
    },
    {
        .name = std::string("pcap"),
        .test_func = test_pcap,
    },
};

struct timeval t1, t2, t3;

long delta_time(struct timeval timeStart, struct timeval timeEnd) {
    return (timeEnd.tv_sec - timeStart.tv_sec) * 1000000 + timeEnd.tv_usec - timeStart.tv_usec;
}

void perform_benchmark(void (*main_test_func)(), int it_count) {
    long d1_sum = 0;
    long d2_sum = 0;
    long d1_sum2 = 0;
    long d2_sum2 = 0;

    std::cout << std::fixed;

    for (int i = 0; i < it_count; i++) {
        main_test_func();
        long d1 = delta_time(t1, t2);
        long d2 = delta_time(t2, t3);
        std::cout << "load: " << d1 << std::endl;
        std::cout << "calc: " << d2 << std::endl;
        d1_sum += d1;
        d2_sum += d2;
        d1_sum2 += d1 * d1;
        d2_sum2 += d2 * d2;
        std::cout << "d2_sum: " << d2_sum << std::endl;
    }

    double d1_avg = (double) d1_sum / 1000000.0 / it_count;
    double d2_avg = (double) d2_sum / 1000000.0 / it_count;

    std::cout << "Ran " << it_count << " iterations" << std::endl;
    std::cout << "load: " << d1_avg << std::endl;
    std::cout << "calc: " << d2_avg << std::endl;
}

int main(int argc, char** argv) {
    int bm_count = sizeof(benchmarks) / sizeof(benchmark_case);

    if (argc != 3) {
        std::cout <<
            "Usage: " << argv[0] << " <benchmark> <iterations>" << std::endl <<
            std::endl <<
            "Available benchmarks:" << std::endl;

        for (int i = 0; i < bm_count; i++) {
            std::cout << "- " << benchmarks[i].name << std::endl;
        }
        return 1;
    }

    void (*main_test_func)() = 0;

    std::string query_name(argv[1]);
    for (int i = 0; i < bm_count; i++) {
        if (query_name == benchmarks[i].name)
            main_test_func = benchmarks[i].test_func;
    }

    if (main_test_func == 0) {
        std::cout << "Benchmark \"" << query_name << "\" is undefined." << std::endl;
        return 2;
    }

    int it_count = std::atoi(argv[2]);

    perform_benchmark(main_test_func, it_count);

    return 0;
}
