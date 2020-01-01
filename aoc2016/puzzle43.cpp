#include <iostream>
#include <string>
#include <vector>
#include "helper.h"

struct Node {
    int x;
    int y;
    int size;
    int used;
    int available;
    int usePercentage;
};

const int gridWidth = 38;
const int gridHeight = 24;
const int nodeNameOffset = 0;
const int nodeNameLength = strlen("/dev/grid/node-x15-y12") - nodeNameOffset;
const int sizeOffset = strlen("/dev/grid/node-x36-y19  ");
const int sizeLength = strlen("/dev/grid/node-x36-y19  508T") - sizeOffset - 1;
const int usedOffset = strlen("/dev/grid/node-x36-y19  508T  ");
const int usedLength = strlen("/dev/grid/node-x36-y19  508T  491T") - usedOffset - 1;
const int availableOffset = strlen("/dev/grid/node-x0-y0     92T   70T   ");
const int availableLength = strlen("/dev/grid/node-x0-y0     92T   70T    22T") - availableOffset - 1;
const int usePercentageOffset = strlen("/dev/grid/node-x0-y0     92T   70T    22T  ");
const int usePercentageLength = strlen("/dev/grid/node-x0-y0     92T   70T    22T   76%") - usePercentageOffset - 1;

std::vector<Node> readInput() {
    int i = 0;
    std::vector<Node> nodes;
    auto lambda = [&](void*, const std::string& line) {
        i++;
        if (i < 3)
            return;
        auto coords = split(line.substr(nodeNameOffset, nodeNameLength), "-");
        Node n;
        n.x = std::stoi(coords[1].substr(1, coords[1].size() - 1));
        n.y = std::stoi(coords[2].substr(1, coords[2].size() - 1));
        n.size = std::stoi(line.substr(sizeOffset, sizeLength));
        n.used = std::stoi(line.substr(usedOffset, usedLength));
        n.available = std::stoi(line.substr(availableOffset, availableLength));
        n.usePercentage = std::stoi(line.substr(usePercentageOffset, usePercentageLength));
        nodes.push_back(n);
    };
    readInputFile(nullptr, lambda);
    return nodes;
}

int main() {
    std::vector<Node> nodes = readInput();
    const int offsets[] = {1, 0, -1, 0, 0, 1, 0, -1};
    int count = 0;
    for (int i = 0; i < nodes.size(); i++) {
        for (int j = 0; j < nodes.size(); j++) {
            if (i == j)
                continue;
            if (nodes[i].used > 0 && nodes[i].used < nodes[j].available)
                count++;
        }
    }
    std::cout << count << std::endl;
    return 0;
}
