#include <iostream>
#include <string>
#include <array>
#include "../helper.h"

std::array<uint64_t, 2> readInput() {
    std::array<uint64_t, 2> input;
    int i = 0;
    auto lambda = [&](const std::string& line) {
        input[i++] = std::stoi(split(line, " ")[4]);
    };
    readInputFile(lambda);
    return input;
}

int main() {
    std::array<uint64_t, 2> generators = readInput();
    int matches = 0;
    uint64_t mask = (1 << 16) - 1;
    for (int i = 0; i < 5000000; i++) {
        do {
            generators[0] *= 16807;
            generators[0] %= 2147483647;
        } while (generators[0] % 4 != 0);
        do {
            generators[1] *= 48271;
            generators[1] %= 2147483647;
        } while (generators[1] % 8 != 0);
        if ((generators[0] & mask) == (generators[1] & mask))
            matches++;
    }
    std::cout << matches << std::endl;    
    return 0;
}
