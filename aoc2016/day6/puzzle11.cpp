#include <iostream>
#include <string>
#include <vector>
#include "../helper.h"

std::string readInput() {
    std::vector<std::vector<int>> charCount;
    auto lambda = [&](void* handler, const std::string& line) {
        while (line.size() > charCount.size()) {
            charCount.push_back(std::vector<int>(28, 0));
        }
        for (int i = 0; i < line.size(); i++) {
            char c = line[i];
            charCount[i][c - 'a'] += 1;
            if (charCount[i][c - 'a'] > charCount[i][26]) {
                charCount[i][26] = charCount[i][c - 'a'];
                charCount[i][27] = c;
            }
        }
    };
    readInputFile(nullptr, lambda);
    std::string result;
    for (int i = 0; i < charCount.size(); i++) {
        result += (char) charCount[i][27];
    }
    return result;
}

int main() {
    std::cout << readInput() << std::endl;
    return 0;
}
