#include <iostream>
#include <vector>
#include <string>
#include <unordered_map>
#include <cmath>
#include <memory>
#include "helper.h"

class ChipHolder {
public:
    virtual int getId() = 0;
    virtual void addChip(int chip) = 0;
};

class Bin : public ChipHolder {
    int id;
    std::vector<int> chips;

public:
    Bin(int id) : id(id) { }

    void addChip(int chip) override {
        chips.push_back(chip);
    }

    int getId() override {
        return id;
    }

    const std::vector<int>& getChips() {
        return chips;
    }
};

class Bot : public ChipHolder {
    int id;
    int numChips = 0;
    int chips[2];
    std::weak_ptr<ChipHolder> lowTarget;
    std::weak_ptr<ChipHolder> highTarget;

public:
    Bot(int id) : id(id) { }

    void setTargets(std::weak_ptr<ChipHolder> lowTarget, std::weak_ptr<ChipHolder> highTarget) {
        this->lowTarget = lowTarget;
        this->highTarget = highTarget;
    }

    void addChip(int chip) override {
        if (numChips < 2)
            chips[numChips++] = chip;
        else
            std::cout << "Bot has too many chips " << id << std::endl;
    }

    bool distributeChips() {
        if (numChips < 2)
            return false;
        if (lowTarget.expired() || highTarget.expired()) {
            std::cout << "Bot " << id << " has no targets but two chips" << std::endl;
            return false;
        }
        int low = std::min(chips[0], chips[1]);
        int high = std::max(chips[0], chips[1]);
        numChips = 0;
        lowTarget.lock()->addChip(low);
        highTarget.lock()->addChip(high);
        return true;
    }

    int getId() override {
        return id;
    }
};

template<typename T>
void addParsed(const std::vector<std::string>& words, const std::string& typeName, 
    std::unordered_map<int, std::shared_ptr<T>>& map,
    std::vector<std::shared_ptr<T>>& vector) 
{
    for (int i = 0; i < words.size(); i += 2) {
        if (words[i] == typeName) {
            int id = std::stoi(words[i + 1]);
            if (map.find(id) == map.end()) {
                auto obj = std::make_shared<T>(id);
                vector.push_back(obj);
                map[id] = obj;
            }
        }
    }
}

void readInput(std::vector<std::shared_ptr<Bot>>& bots, 
    std::unordered_map<int, std::shared_ptr<Bin>>& binsMap) 
{
    std::unordered_map<int, std::shared_ptr<Bot>> botsMap;
    std::vector<std::shared_ptr<Bin>> bins;
    std::vector<std::string> input;
    auto lambda = [&](void* handler, const std::string& line) {
        input.push_back(line);
        auto parts = split(line, " ");
        if (parts[0] == "bot") {
            std::vector<std::string> words = { parts[0], parts[1], parts[5], parts[6], parts[10], parts[11] };
            addParsed<Bot>(words, "bot", botsMap, bots);
            addParsed<Bin>(words, "output", binsMap, bins);
        } else {
            int id = std::stoi(parts[5]);
            auto obj = std::make_shared<Bot>(id);
            bots.push_back(obj);
            botsMap[id] = obj;
        }
    };
    readInputFile(nullptr, lambda);
    for (const auto& line : input) {
        auto parts = split(line, " ");
        if (parts[0] == "bot") {
            int id0 = std::stoi(parts[1]);
            int id1 = std::stoi(parts[6]);
            int id2 = std::stoi(parts[11]);
            auto bot = botsMap[id0];
            std::shared_ptr<ChipHolder> lowTarget;
            std::shared_ptr<ChipHolder> highTarget;
            lowTarget = parts[5] == "bot" ? botsMap[id1] : static_cast<std::shared_ptr<ChipHolder>>(binsMap[id1]);
            highTarget = parts[10] == "bot" ? botsMap[id2] : static_cast<std::shared_ptr<ChipHolder>>(binsMap[id2]);
            bot->setTargets(lowTarget, highTarget);
        } else {
            botsMap[std::stoi(parts[5])]->addChip(std::stoi(parts[1]));
        }
    }
}

int main() {
    std::vector<std::shared_ptr<Bot>> bots;
    std::unordered_map<int, std::shared_ptr<Bin>> binsMap;
    readInput(bots, binsMap);
    bool end = false;
    while (!end) {
        end = true;
        for (const auto& bot : bots) {
            if (bot->distributeChips())
                end = false;
        }
    }
    int result = 1;
    for (int i = 0; i < 3; i++) {
        result *= binsMap[i]->getChips()[0];
    }
    std::cout << result << std::endl;
    return 0;
}
