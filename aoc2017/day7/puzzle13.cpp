#include <string>
#include <iostream>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <memory>
#include "../helper.h"

struct Node {
    std::string name;
    int weight;
    std::vector<std::string> children;

    Node(std::string name, int weight, std::vector<std::string> children) {
        this->name = name;
        this->weight = weight;
        this->children = children;
    }
};

std::unordered_map<std::string, std::unique_ptr<Node>> readInput() {
    std::unordered_map<std::string, std::unique_ptr<Node>> nodes;
    auto lambda = [&](const std::string& line){
        auto nodeAndEdges = split(line, " -> ");
        auto nodeNameAndWeight = split(nodeAndEdges[0], " ");
        auto nodeName = nodeNameAndWeight[0];
        auto nodeWeight = std::stoi(nodeNameAndWeight[1].substr(1, nodeNameAndWeight[1].size() - 1));
        auto children = std::vector<std::string>();
        if (nodeAndEdges.size() > 1)
            children = split(nodeAndEdges[1], ", ");
        nodes[nodeName] = std::make_unique<Node>(Node(nodeName, nodeWeight, children));
    };
    readInputFile(lambda);
    return nodes;
}

int main() {
    auto nodes = readInput();
    std::unordered_set<std::string> nodeNames;
    for (auto iter = nodes.begin(); iter != nodes.end(); iter++) {
        nodeNames.insert(iter->first);
    }
    for (auto iter = nodes.begin(); iter != nodes.end(); iter++) {
        for (const auto& child : iter->second->children)
            nodeNames.erase(child);
    }
    for (auto iter = nodeNames.begin(); iter != nodeNames.end(); iter++) {
        std::cout << *iter << std::endl;
    }
    return 0;
}
