#include <iostream>
#include <string>
#include <vector>
#include "helper.h"

std::string readInput() {
    std::vector<std::vector<int>> charCount;
    auto lambda = [&](void* handler, const std::string& line) {
        while (line.size() > charCount.size()) {
            charCount.push_back(std::vector<int>(26, 0));
        }
        for (int i = 0; i < line.size(); i++) {
            char c = line[i];
            charCount[i][c - 'a'] += 1;
        }
    };
    readInputFile(nullptr, lambda);
    std::string result;
    for (int i = 0; i < charCount.size(); i++) {
        int32_t min = ~(1 << 31);
        char c = '?';
        for (int j = 0; j < 26; j++) {
            if (charCount[i][j] != 0 && charCount[i][j] < min) {
                c = j + 'a';
                min = charCount[i][j];
            }
        }
        result += c;
    }
    return result;
}

int main() {
    std::cout << readInput() << std::endl;
    return 0;
}
