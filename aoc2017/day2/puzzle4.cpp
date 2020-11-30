#include <iostream>
#include <string>
#include <vector>
#include <cmath>
#include "../helper.h"

int readInput() {
    int checksum = 0;
    auto lambda = [&](const std::string& line) {
        auto parts = split(line, "\t");
        int min = ~(1 << 31);
        int max = 0;
        for (int i = 0; i < parts.size(); i++) {
            int n1 = std::stoi(parts[i]);
            for (int j = 0; j < parts.size(); j++) {
                int n2 = std::stoi(parts[j]);
                if (n1 % n2 == 0 && i != j) {
                    checksum += n1 / n2;
                }
            }
        }
    };
    readInputFile(lambda);
    return checksum;
}

int main() {
    std::cout << readInput() << std::endl;
}
