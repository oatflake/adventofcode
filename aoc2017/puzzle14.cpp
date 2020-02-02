#include <string>
#include <iostream>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <memory>
#include <tuple>
#include <algorithm>
#include "helper.h"

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

std::tuple<bool, int> findFaulty(std::string nodeName, 
    std::unordered_map<std::string, std::unique_ptr<Node>>& nodes) 
{
    int weight = nodes[nodeName]->weight;
    std::vector<int> childrenWeights;
    for (const auto& child : nodes[nodeName]->children) {
        bool faultyFix;
        int childWeight;
        std::tie(faultyFix, childWeight) = findFaulty(child, nodes);
        if (faultyFix)
            return std::make_tuple(true, childWeight);
        childrenWeights.push_back(childWeight);
        weight += childWeight;
    }
    if (childrenWeights.size() > 1) {
        std::vector<int> childrenWeightsSorted = childrenWeights;
        std::sort(childrenWeightsSorted.begin(), childrenWeightsSorted.end());
        if (childrenWeightsSorted[0] != childrenWeightsSorted[1]) {
            int difference = childrenWeightsSorted[0];
            difference -= childrenWeightsSorted[1];
            for (int i = 0; i < childrenWeights.size(); i++) {
                if (childrenWeights[i] == childrenWeightsSorted[0]) {
                    return std::make_tuple(true, nodes[nodes[nodeName]->children[i]]->weight - difference);
                }
            }
        }
        if (childrenWeightsSorted[childrenWeights.size() - 1] != 
            childrenWeightsSorted[childrenWeights.size() - 2])
        {
            int difference = childrenWeightsSorted[childrenWeights.size() - 2]; 
            difference -= childrenWeightsSorted[childrenWeights.size() - 1];
            for (int i = 0; i < childrenWeights.size(); i++) {
                if (childrenWeights[i] == childrenWeightsSorted[childrenWeights.size() - 1]) {
                    return std::make_tuple(true, nodes[nodes[nodeName]->children[i]]->weight + difference);
                }
            }
        }
    }
    return std::make_tuple(false, weight);
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
    bool faultyFix;
    int childWeight;        
    std::tie(faultyFix, childWeight) = findFaulty(*nodeNames.begin(), nodes);
    std::cout << childWeight << std::endl;
    return 0;
}
