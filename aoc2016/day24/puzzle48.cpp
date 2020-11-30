#include <iostream>
#include <string>
#include <cmath>
#include <queue>
#include <unordered_set>
#include <tuple>
#include <vector>
#include "../helper.h"

std::tuple<std::string, int, int> readInput() {
    std::string map;
    int width = 0;
    int height = 0;
    auto lambda = [&](void*, const std::string& line){
        height++;
        width = line.size();
        map += line;
    };
    readInputFile(nullptr, lambda);
    return std::make_tuple(map, width, height);
}

void bfs(const std::string& map, int width, int height, int startPos, std::vector<int>& targets) {
    int offsets[8] = { 1, 0, -1, 0, 0, 1, 0, -1 };
    std::queue<std::tuple<int, int>> queue;
    queue.push(std::make_tuple(startPos, 0));
    std::unordered_set<int> visited;
    while (!queue.empty()) {
        int currentPos;
        int steps;
        std::tie(currentPos, steps) = queue.front();
        queue.pop();
        int x = currentPos % width;
        int y = currentPos / width;
        if (visited.find(currentPos) != visited.end())
            continue;
        if (std::isdigit(map[currentPos]))
            targets[map[currentPos] - '0'] = steps;
        visited.insert(currentPos);
        for (int i = 0; i < 8; i += 2) {
            int nx = x + offsets[i];
            int ny = y + offsets[i + 1];
            if (nx < 0 || nx >= width || ny < 0 || ny >= height)
                continue;
            int nID = nx + ny * width;
            if (visited.find(nID) != visited.end())
                continue;
            if (map[nID] == '#')
                continue;
            queue.push(std::make_tuple(nID, steps + 1));
        }
    }
}

int permutations(int n, std::vector<int>& permutation, const std::vector<int>& adjMatrix) {
    if (n == permutation.size() - 1) {
        int currentPos = 0;
        int pathCost = 0;
        int targets = permutation.size() + 1;
        for (int p : permutation) {
            pathCost += adjMatrix[currentPos * targets + p];
            currentPos = p;
        }
        return pathCost + adjMatrix[currentPos * targets + 0];
    }
    int pathCost = ~(1 << 31);
    for (int i = n; i < permutation.size(); i++) {
        int tmp = permutation[i];
        permutation[i] = permutation[n];
        permutation[n] = tmp;
        pathCost = std::min(pathCost, permutations(n + 1, permutation, adjMatrix));
        permutation[n] = permutation[i];
        permutation[i] = tmp;
    }
    return pathCost;
}

int main() {
    int width;
    int height;
    std::string map;
    std::tie(map, width, height) = readInput();
    int maxTargets = 0;
    for (int i = 0; i < map.size(); i++) {
        char c = map[i];
        if (std::isdigit(c)) {
            maxTargets = std::max(maxTargets, c - '0');
        }
    }
    std::vector<int> startPos(maxTargets + 1, -1);
    for (int i = 0; i < map.size(); i++) {
        char c = map[i];
        if (std::isdigit(c)) {
            startPos[c - '0'] = i;
        }
    }
    std::vector<int> adjMatrix;
    std::vector<int> targets(maxTargets + 1, -1);
    for (int i = 0; i < startPos.size(); i++) {
        bfs(map, width, height, startPos[i], targets);
        adjMatrix.insert(adjMatrix.end(), targets.begin(), targets.end());
    }
    std::vector<int> visitOrder(maxTargets, -1);
    for (int i = 0; i < visitOrder.size(); i++) {
        visitOrder[i] = i + 1;
    }
    std::cout << permutations(0, visitOrder, adjMatrix) << std::endl;
    return 0;
}
