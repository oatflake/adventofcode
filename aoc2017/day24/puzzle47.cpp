#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>
#include <tuple>
#include <unordered_set>
#include "../helper.h"

int connectPorts(std::unordered_set<int>& visited, 
    std::unordered_map<int, std::vector<std::tuple<int,int>>>& map, int current) 
{
    auto list = map[current];
    int maxPath = 0;
    for (auto entry : list) {
        int id;
        int port;
        std::tie(id, port) = entry;
        if (visited.find(id) == visited.end()) {
            visited.insert(id);
            maxPath = std::max(maxPath, current + port + connectPorts(visited, map, port));
            visited.erase(id);
        }
    }
    return maxPath;
}

std::vector<std::tuple<int,int>> readInput() {
    std::vector<std::tuple<int,int>> components;
    auto lambda = [&](const std::string& line) {
        auto splitLine = split(line, "/");
        int a = std::stoi(splitLine[0]);
        int b = std::stoi(splitLine[1]);
        std::tuple<int, int> tuple = { a, b };
        components.push_back(tuple);
    };
    readInputFile(lambda);
    return components;
}

int main() {
    auto components = readInput();
    std::unordered_map<int, std::vector<std::tuple<int,int>>> componentsMap;
    int ids = 0;
    for (auto component : components) {
        int port1;
        int port2;
        std::tie(port1, port2) = component;
        componentsMap[port1].push_back({ ids, port2 });
        componentsMap[port2].push_back({ ids, port1 });
        ids++;
    }
    std::unordered_set<int> set;
    std::cout << connectPorts(set, componentsMap, 0) << std::endl;
    return 0;
}
