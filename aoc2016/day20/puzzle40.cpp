#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <cmath>
#include "../helper.h"

struct Range {
    uint32_t begin;
    uint32_t end;
    Range(uint32_t begin, uint32_t end) : begin(begin), end(end) { }
};

std::vector<Range> readInput() {
    std::vector<Range> ranges;
    auto lambda = [&](void*, const std::string& line){
        std::vector<std::string> parts = split(line, "-");
        ranges.push_back(Range(std::stoul(parts[0]), std::stoul(parts[1])));
    };
    readInputFile(nullptr, lambda);
    return ranges;
}

int main() {
    std::vector<Range> ranges = readInput();
    std::sort(ranges.begin(), ranges.end(), [](Range a, Range b) {
        return a.begin < b.begin;   
    });
    Range current = ranges[0];
    uint32_t maxEnd = current.end;
    uint32_t allowed = 0;
    for (int i = 1; i < ranges.size(); i++) {
        if (maxEnd < ranges[i].begin - 1) {
            allowed += ranges[i].begin - maxEnd - 1;
        }
        current = ranges[i];
        maxEnd = std::max(current.end, maxEnd);
    }
    std::cout << allowed << std::endl;
    return 0;
}
