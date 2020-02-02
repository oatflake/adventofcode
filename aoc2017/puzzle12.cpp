#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
#include "helper.h"

std::vector<int> readInput() {
    std::vector<int> result;
    auto lambda = [&](std::string line) {
        auto parts = split(line, "\t");
        for (auto part : parts) {
            result.push_back(std::stoi(part));
        }
    };
    readInputFile(lambda);
    return result;
}

struct Memory {
    std::vector<int> banks;
    Memory(std::vector<int> banks) {
        this->banks = banks;
    }
};

bool operator==(const Memory& lhs, const Memory& rhs) {
    bool same = true;
    if (lhs.banks.size() != rhs.banks.size())
        return false;
    for (int i = 0; i < lhs.banks.size(); i++) {
        same = same && lhs.banks[i] == rhs.banks[i];
    }
    return same;
}

namespace std {
template<>
struct hash<Memory> {
    std::size_t operator()(Memory const& s) const {
        std::size_t res = 0;
        for (int i = 0; i < s.banks.size(); i++) {
            hash_combine(res, s.banks[i]);
        }
        return res;
    }
};
}

int main() {
    auto banks = readInput();
    std::unordered_map<Memory, int> map;
    int k = 0;
    int k0 = 0;
    while(true) {
        auto m = Memory(banks);
        auto iter = map.find(m);
        if (iter != map.end()) {
            k0 = iter->second;
            break;
        }
        map[m] = k;
        int maxBank = 0;
        int maxBankIndex = 0;
        for (int i = 0; i < banks.size(); i++) {
            if (banks[i] > maxBank) {
                maxBank = banks[i];
                maxBankIndex = i;
            }
        }
        banks[maxBankIndex] = 0;
        while (maxBank > 0) {
            maxBankIndex = (maxBankIndex + 1) % banks.size();
            banks[maxBankIndex]++;
            maxBank--;
        }
        k++;
    }
    std::cout << k - k0 << std::endl;
    return 0;
}
