#include <iostream>
#include <string>
#include <vector>
#include "helper.h"

std::vector<int> readInput() {
    std::vector<int> lengths;
    auto lambda = [&](const std::string& line) {
        for (char c : line)
            lengths.push_back((int)c);
    };
    readInputFile(lambda);
    std::vector<int> suffix = { 17, 31, 73, 47, 23 };
    for (int length : suffix)
        lengths.push_back(length);
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
    for (int r = 0; r < 64; r++) {
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
    }
    std::vector<int> dense;
    int x = 0;
    for (int i = 0; i < ring.size(); ) {
        x ^= ring[i];
        i++;
        if (i % 16 == 0) {
            dense.push_back(x);
            x = 0;
        }
    }
    std::string output;
    for (int i = 0; i < dense.size(); i++) {
        int a = dense[i] / 16;
        int b = dense[i] % 16;
        output.push_back(a < 10 ? '0' + a : 'a' + (a - 10));
        output.push_back(b < 10 ? '0' + b : 'a' + (b - 10));
    }
    std::cout << output << std::endl;
}
