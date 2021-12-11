// compile with -std=c++1z

#include <iostream>
#include <tuple>
#include "../helper.h"

std::tuple<std::vector<int>, int, int> readInput() {
    std::vector<int> grid;
    int width = 0;
    int height = 0;
    auto lambda = [&](const std::string& line){
        height++;
        width = line.length();
        for (char c : line)
            grid.push_back(c - '0');
    };
    readInputFile(lambda);
    return { grid, width, height };
}

int simulate(std::vector<int>& grid, int width, int height) {
    int flashes = 0;
    std::vector<int> flashers;
    for (int i = 0; i < grid.size(); i++) {
        grid[i]++;
        if (grid[i] > 9)
            flashers.push_back(i);
    }
    while (!flashers.empty()) {
        int flasher = flashers.back();
        flashers.pop_back();
        if (grid[flasher] == -1) // has already flashed
            continue;
        flashes++;
        int x = flasher % width;
        int y = flasher / width;
        grid[flasher] = -1;
        for (int j = std::max(y - 1, 0); j < std::min(y + 2, height); j++) {
            for (int i = std::max(x - 1, 0); i < std::min(x + 2, width); i++) {
                int neighbor = i + j * width;
                if (grid[neighbor] != -1)
                    grid[i + j * width]++;
                if (grid[neighbor] > 9)
                    flashers.push_back(neighbor);
            }
        }
    }
    for (int i = 0; i < grid.size(); i++) {
        if (grid[i] == -1)
            grid[i] = 0;
    }
    return flashes;
}

int main() {
    auto[grid, width, height] = readInput();
    int flashes = 0;
    for (int i = 0; i < 100; i++) {
        flashes += simulate(grid, width, height);
    }
    std::cout << flashes << std::endl;
}