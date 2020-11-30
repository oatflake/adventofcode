#include <iostream>
#include <string>
#include <vector>
#include <queue>
#include <unordered_set>
#include <cmath>
#include "../helper.h"

struct Node {
    int x;
    int y;
    int size;
    int used;
    int available;
    int usePercentage;
};

int gridWidth = 0;
int gridHeight = 0;
const int nodeNameOffset = 0;
const int nodeNameLength = strlen("/dev/grid/node-x15-y12") - nodeNameOffset;
const int sizeOffset = strlen("/dev/grid/node-x36-y19 ");
const int sizeLength = strlen("/dev/grid/node-x36-y19  508T") - sizeOffset - 1;
const int usedOffset = strlen("/dev/grid/node-x36-y19  508T ");
const int usedLength = strlen("/dev/grid/node-x36-y19  508T  491T") - usedOffset - 1;
const int availableOffset = strlen("/dev/grid/node-x0-y0     92T   70T  ");
const int availableLength = strlen("/dev/grid/node-x0-y0     92T   70T    22T") - availableOffset - 1;
const int usePercentageOffset = strlen("/dev/grid/node-x0-y0     92T   70T    22T ");
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
        gridWidth = std::max(gridWidth, n.x);
        n.y = std::stoi(coords[2].substr(1, coords[2].size() - 1));
        gridHeight = std::max(gridHeight, n.y);
        n.size = std::stoi(line.substr(sizeOffset, sizeLength));
        n.used = std::stoi(line.substr(usedOffset, usedLength));
        n.available = std::stoi(line.substr(availableOffset, availableLength));
        n.usePercentage = std::stoi(line.substr(usePercentageOffset, usePercentageLength));
        nodes.push_back(n);
    };
    readInputFile(nullptr, lambda);
    gridWidth++;
    gridHeight++;
    return nodes;
}

int bfs(const std::vector<Node>& nodes) {
    const Vec2i offsets[] = { vec2i(1, 0), vec2i(-1, 0), vec2i(0, 1), vec2i(0, -1) };
    std::queue<std::tuple<Vec2i, int>> queue;
    for (int i = 0; i < nodes.size(); i++) {
        if (nodes[i].used == 0) {
            queue.push(std::make_tuple(vec2i(i, 0 + (gridWidth - 1) * gridHeight), 0));
            break;
        }
    }
    std::unordered_set<Vec2i> visited;
    while (!queue.empty()) {
        Vec2i currentIDs;
        int steps;
        std::tie(currentIDs, steps) = queue.front();
        queue.pop();
        if (currentIDs[1] == 0)
            return steps;
        if (visited.find(currentIDs) != visited.end())
            continue;
        visited.insert(currentIDs);
        Node currentNode = nodes[currentIDs[0]];
        for (int i = 0; i < 4; i++) {
            Vec2i neighborPos = vec2i(currentNode.x, currentNode.y) + offsets[i];
            if (neighborPos[0] < 0 || neighborPos[0] >= gridWidth || 
                neighborPos[1] < 0 || neighborPos[1] >= gridHeight)
            {
                continue;
            }
            int neighborID = neighborPos[1] + neighborPos[0] * gridHeight;
            Node neighbor = nodes[neighborID];
            if (neighbor.used > currentNode.size)
                continue;
            int goalID = neighborID == currentIDs[1] ? currentIDs[0] : currentIDs[1];
            Vec2i next = vec2i(neighborID, goalID);
            if (visited.find(next) != visited.end())
                continue;
            queue.push(std::make_tuple(next, steps + 1));
        }
    }
    return -1;
}

int main() {
    std::vector<Node> nodes = readInput();
    std::cout << bfs(nodes) << std::endl;
    return 0;
}
