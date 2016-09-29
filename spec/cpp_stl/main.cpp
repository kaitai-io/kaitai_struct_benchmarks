#include <sys/time.h>

#include <iostream>

void test_benchmark_process_xor();

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
        .test_func = 0, //test_ext2,
    },
};

struct timeval t1, t2, t3;

void report_time(std::string caption, struct timeval timeStart, struct timeval timeEnd) {
    std::cout << caption << " : " << ((timeEnd.tv_sec - timeStart.tv_sec) * 1000000 + timeEnd.tv_usec - timeStart.tv_usec) << std::endl;
}

int main(int argc, char** argv) {
    int bm_count = sizeof(benchmarks) / sizeof(benchmark_case);

    if (argc != 2) {
        std::cout <<
            "Usage: " << argv[0] << " <benchmark>" << std::endl <<
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

    main_test_func();

    report_time("load", t1, t2);
    report_time("calc", t2, t3);

    return 0;
}
