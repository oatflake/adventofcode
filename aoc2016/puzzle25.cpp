#include <iostream>
#include <string>
#include <queue>
#include <unordered_set>
#include "helper.h"

const int input = 1350;

bool isWall(Vec2i v) {
    int x = v[0];
    int y = v[1];
    int a = x*x + 3*x + 2*x*y + y + y*y;
    a += input;
    int b = 0;
    for (int i = 0; i < 32; i++) {
        b += a & 1;
        a >>= 1;
    }
    return b % 2;
}

int bfs(Vec2i start, Vec2i goal) {
    std::queue<std::tuple<Vec2i, int>> queue;
    std::unordered_set<Vec2i> visited;
    queue.push(std::make_tuple(start, 0));
    Vec2i offsets[4] = { vec2i(-1, 0), vec2i(1, 0), vec2i(0, -1), vec2i(0, 1) };
    while (!queue.empty()) {
        Vec2i current;
        int steps;
        std::tie(current, steps) = queue.front();
        queue.pop();
        if (visited.find(current) != visited.end())
            continue;
        visited.insert(current);
        if (current == goal)
            return steps;
        for (int i = 0; i < 4; i++) {
            auto neighbor = current + offsets[i];
            if (neighbor[0] < 0 || neighbor[1] < 0)
                continue;
            if (isWall(neighbor))
                continue;
            if (visited.find(neighbor) != visited.end())
                continue;
            queue.push(std::make_tuple(neighbor, steps + 1));
        }
    }
    return -1;
}

int main() {
    std::cout << bfs(vec2i(1, 1), vec2i(31, 39)) << std::endl;
    return 0;
}
