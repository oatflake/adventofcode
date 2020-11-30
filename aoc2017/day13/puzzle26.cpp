#include <iostream>
#include <string>
#include <vector>
#include "../helper.h"

struct Firewall {
    int layer;
    int range; 
    Firewall(int layer, int range) {
        this->layer = layer;
        this->range = range;
    }
};

std::vector<Firewall> readInput() {
    std::vector<Firewall> firewalls;
    auto lambda = [&](const std::string& line){
        auto parts = split(line, ": ");
        firewalls.push_back(Firewall(std::stoi(parts[0]), std::stoi(parts[1])));
    };
    readInputFile(lambda);
    return firewalls;
}

int main() {
    auto firewalls = readInput();
    int severity = 0;
    int ps = 0;
    for (; ps < 10000000; ps++) {
        bool ok = true;
        for (auto f : firewalls) {
            if ((f.layer + ps) % ((f.range - 1) * 2) == 0) {
                ok = false;
                break;
            }
        }
        if (ok)
            break;
    }
    std::cout << ps << std::endl;
    return 0;
}
