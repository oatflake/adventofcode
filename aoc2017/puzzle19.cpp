#include <iostream>
#include <string>
#include <vector>
#include "helper.h"

std::vector<int> readInput() {
    std::vector<int> lengths;
    auto lambda = [&](const std::string& line) {
        auto parts = split(line, ",");
        for (const auto& part : parts)
            lengths.push_back(std::stoi(part)); 
    };
    readInputFile(lambda);
    return lengths;
}

int main() {
    auto lengths = readInput();
    std::vector<int> ring;
    for (int i = 0; i < 256; i++) {
        ring.push_back(i);
    }
    int skipSize = 0;
    int currentPos = 0;
    for (int length : lengths) {
        for (int i = 0; i < length / 2; i++) {
            int a = (currentPos + i) % 256;
            int b = (currentPos + length - 1 - i) % 256;
            int tmp = ring[b];
            ring[b] = ring[a];
            ring[a] = tmp;
        }
        currentPos += length + skipSize;
        skipSize++;
    }
    std::cout << ring[0] * ring[1] << std::endl;
}
