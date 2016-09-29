#include <ext2.h>

#include <fstream>
#include <vector>
#include <iostream>
#include <sys/time.h>

std::string dot(".");
std::string dot2("..");

long calc_dir(ext2_t::dir_t* dir) {
    long sum = 0;

    for (uint i = 0; i < dir->entries()->size(); i++) {
        auto entry = dir->entries()->operator[](i);
        if (entry->name() == dot || entry->name() == dot2)
            continue;

        switch (entry->file_type()) {
        case ext2_t::dir_entry_t::FILE_TYPE_REG_FILE:
            sum += entry->inode()->size();
            break;
        case ext2_t::dir_entry_t::FILE_TYPE_DIR:
            sum += calc_dir(entry->inode()->as_dir());
            break;
        }
    }
    return sum;
}

extern struct timeval t1, t2, t3;

void test_ext2() {
    std::ifstream ifs("data/ext2.dat", std::ifstream::binary);
    kaitai::kstream ks(&ifs);

    gettimeofday(&t1, NULL);
    ext2_t r(&ks);
    gettimeofday(&t2, NULL);
    long sum = calc_dir(r.root_dir());
    gettimeofday(&t3, NULL);

    std::cout << "sum = " << sum << std::endl;
}
