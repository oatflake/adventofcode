#include <iostream>
#include <string>
#include <vector>
#include <cmath>
#include "helper.h"

int readInput() {
    int checksum = 0;
    auto lambda = [&](const std::string& line) {
        auto parts = split(line, "\t");
        int min = ~(1 << 31);
        int max = 0;
        for (auto part : parts) {
            int n = std::stoi(part);
            min = std::min(min, n);
            max = std::max(max, n);
        }
        checksum += max - min;
    };
    readInputFile(lambda);
    return checksum;
}

int main() {
    std::cout << readInput() << std::endl;
}
