#include <iostream>
#include <string>
#include "../helper.h"

void collectABA(const std::string& word, std::vector<std::string>& abas) {
    for (int i = 0; i < word.size() - 2; i++) {
        if (word[i] == word[i + 2] && word[i] != word[i + 1])
            abas.push_back(word.substr(i, i + 2));
    }
}

bool corresponds(const std::vector<std::string>& abas, const std::vector<std::string>& babs) {
    for (const auto& aba : abas) {
        for (const auto& bab : babs) {
            if (aba[0] == bab[1] && aba[1] == bab[0])
                return true;
        }
    }
    return false;
}

int readInput() {
    int sslIPs = 0;
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
        std::vector<std::string> babs;
        for (const auto& part : innerParts) {
            collectABA(part, babs);
        }
        std::vector<std::string> abas;
        for (const auto& part : outerParts) {
            collectABA(part, abas);
        }
        if (corresponds(abas, babs))
            sslIPs++;
    };
    readInputFile(nullptr, lambda);
    return sslIPs;
}

int main() {
    std::cout << readInput() << std::endl;
    return 0;
}
