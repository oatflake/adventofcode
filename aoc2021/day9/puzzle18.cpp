// compile with -std=c++1z

#include <iostream>
#include <vector>
#include <tuple>
#include <unordered_map>
#include <queue>
#include <algorithm>
#include "../helper.h"

std::tuple<int, int, std::vector<int>> readInput() {
    int width = 0;
    int height = 0;
    std::vector<int> heightMap;
    auto lambda = [&](const std::string& line) {
        width = line.length();
        height++;
        for (char c : line) {
            heightMap.push_back(c - '0');
        }
    };
    readInputFile(lambda);
    return { width, height, heightMap };
}

std::vector<std::tuple<int, int>> findLowPoints(int width, int height, const std::vector<int>& heightMap) {
    std::vector<std::tuple<int, int>> lowPoints;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int altitude = heightMap[x + y * width];
            if (x > 0 && heightMap[x - 1 + y * width] <= altitude)
                continue;
            if (x < width - 1 && heightMap[x + 1 + y * width] <= altitude)
                continue;
            if (y > 0 && heightMap[x + (y - 1) * width] <= altitude)
                continue;
            if (y < height - 1 && heightMap[x + (y + 1) * width] <= altitude)
                continue;
            lowPoints.push_back({ x, y });
        }
    }
    return lowPoints;
}

std::unordered_map<int, int> floodFill(const std::vector<std::tuple<int, int>> lowPoints, 
    int width, int height, const std::vector<int>& heightMap) 
{
    std::unordered_map<int, int> seen;
    std::queue<std::tuple<int, int, int>> open;
    std::array<std::tuple<int, int>, 4> deltas = { std::make_tuple(1, 0), { -1, 0 }, { 0, 1 }, { 0, -1 } };
    for (const auto& [startX, startY] : lowPoints) {
        int i = startX + startY * width;
        open.push({ startX, startY, i });
        seen[i] = i;
    }
    while (!open.empty()) {
        auto[x,y,lowPointID] = open.front();
        open.pop();
        int i = x + y * width;
        int altitude = heightMap[i];
        for (const auto&[dx, dy] : deltas) {
            int nx = x + dx;
            int ny = y + dy;
            if (nx < 0 || nx >= width || ny < 0 || ny >= height)
                continue;
            int ni = nx + ny * width;
            int nAltitude = heightMap[ni];
            if (nAltitude == 9)
                continue;
            if (seen.find(ni) != seen.end())
                continue;
            seen[ni] = lowPointID;
            open.push({ nx, ny, lowPointID });
        }
    }
    return seen;
}

int main() {
    auto[width, height, heightMap] = readInput();
    auto lowPoints = findLowPoints(width, height, heightMap);
    auto markedLocations = floodFill(lowPoints, width, height, heightMap);
    std::unordered_map<int, int> besinSizesMap;
    for (const auto& [x,y] : lowPoints)
        besinSizesMap[x + y * width] = 0;
    for (const auto& location : markedLocations) {
        besinSizesMap[location.second] += 1;
    }
    std::vector<int> besinSizes;
    for (const auto& besinSize : besinSizesMap)
        besinSizes.push_back(besinSize.second);
    std::sort(besinSizes.begin(), besinSizes.end(), [](int x, int y){ return x > y; });
    std::cout << besinSizes[0] * besinSizes[1] * besinSizes[2] << std::endl;
    return 0;
}