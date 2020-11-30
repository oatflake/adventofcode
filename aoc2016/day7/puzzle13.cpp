#include <iostream>
#include <string>
#include "../helper.h"

bool containsABBA(const std::string& word) {
    for (int i = 0; i < word.size() - 3; i++) {
        if (word[i] == word[i + 3] && word[i + 1] == word[i + 2] && word[i] != word[i + 1])
            return true;
    }
    return false;
}

int readInput() {
    int tlsIPs = 0;
    auto lambda = [&](void* handler, const std::string& line) {
        std::vector<std::string> splitLine = split(line, "[");
        std::vector<std::string> outerParts;
        std::vector<std::string> innerParts;
        outerParts.push_back(splitLine[0]);
        for (int i = 1; i < splitLine.size(); i++) {
            std::vector<std::string> parts = split(splitLine[i], "]");
            innerParts.push_back(parts[0]);
            outerParts.push_back(parts[1]);
        }
        for (const auto& part : innerParts) {
            if (containsABBA(part))
                return;
        }
        for (const auto& part : outerParts) {
            if (containsABBA(part)) {
                tlsIPs++;
                return;
            }
        }
    };
    readInputFile(nullptr, lambda);
    return tlsIPs;
}

int main() {
    std::cout << readInput() << std::endl;
    return 0;
}
