#include <iostream>
#include <string>
#include <vector>
#include <unordered_map>
#include <unordered_set>
#include <tuple>
#include <algorithm>
#include <queue>
#include "../helper.h"

const int8_t MAX_ARRAY_LENGTH = 5;
struct State {
    int8_t elevator;
    int8_t generators[MAX_ARRAY_LENGTH];
    int8_t microchips[MAX_ARRAY_LENGTH];
};

bool operator==(const State& lhs, const State& rhs) {
    bool same = true;
    same = same && lhs.elevator == rhs.elevator;
    for (int i = 0; i < MAX_ARRAY_LENGTH; i++) {
        same = same && lhs.generators[i] == rhs.generators[i];
        same = same && lhs.microchips[i] == rhs.microchips[i];
    }
    return same;
}

namespace std {
template<>
struct hash<State> {
    std::size_t operator()(State const& s) const {
        std::size_t res = 0;
        hash_combine(res, s.elevator);
        for (int i = 0; i < MAX_ARRAY_LENGTH; i++) {
            hash_combine(res, s.generators[i]);
        }
        for (int i = 0; i < MAX_ARRAY_LENGTH; i++) {
            hash_combine(res, s.microchips[i]);
        }
        return res;
    }
};
}

struct StateInfo {
    std::vector<std::string> names;
};

std::tuple<State, StateInfo> readInput() {
    std::unordered_map<std::string, int8_t> generators;
    std::unordered_map<std::string, int8_t> microchips;
    StateInfo info;
    int floor = 0;
    auto lambda = [&](void* handler, const std::string& line) {
        auto parts = split(line, " ");
        for (int i = 0; i < parts.size(); i++) {
            if (parts[i].compare(0, sizeof("generator") - 1, "generator") == 0) {
                info.names.push_back(parts[i - 1]);
                generators[parts[i - 1]] = floor;
            } else if (parts[i].compare(0, sizeof("microchip") - 1, "microchip") == 0) {
                microchips[split(parts[i - 1], "-")[0]] = floor;
            }
        }
        floor++;
    };
    readInputFile(nullptr, lambda);
    std::sort(info.names.begin(), info.names.end());
    State state;
    state.elevator = 0;
    for (int i = 0; i < info.names.size(); i++) {
        state.generators[i] = generators[info.names[i]];
        state.microchips[i] = microchips[info.names[i]];
    }
    return std::tuple<State, StateInfo>(state, info);
}

class Solver {
    const int stateLength;

    bool takeItem(const State& state, int generators[], int numGenerators, 
        int microchips[], int numMicrochips, int elevator, State&result) 
    {
        for (int g = 0; g < numGenerators; g++) {
            if (state.generators[generators[g]] != state.elevator)
                return false;
        }
        for (int m = 0; m < numMicrochips; m++) {
            if (state.microchips[microchips[m]] != state.elevator)
                return false;
        }
        result.elevator = elevator;
        for (int i = 0; i < MAX_ARRAY_LENGTH; i++) {
            result.generators[i] = state.generators[i];
            result.microchips[i] = state.microchips[i];
        }
        for (int i = 0; i < numGenerators; i++) {
            result.generators[generators[i]] = elevator;
        }
        for (int i = 0; i < numMicrochips; i++) {
            result.microchips[microchips[i]] = elevator;
        }
        return true;
    }

    std::vector<State> neighborStates(const State& state) {
        std::vector<State> results;
        int generators[2];
        int microchips[2];
        State neighborState;
        for (int elevatorOffset = -1; elevatorOffset < 2; elevatorOffset += 2) {
            int elevator = state.elevator + elevatorOffset;
            if (elevator < 0 || elevator > 3)
                continue;
            for (int i = 0; i < stateLength; i++) {
                generators[0] = i;
                if (takeItem(state, generators, 1, microchips, 0, elevator, neighborState))
                    results.push_back(neighborState);
                microchips[0] = i;
                if (takeItem(state, generators, 0, microchips, 1, elevator, neighborState))
                    results.push_back(neighborState);
                for (int j = i + 1; j < stateLength; j++) {
                    generators[1] = j;
                    if (takeItem(state, generators, 2, microchips, 0, elevator, neighborState))
                        results.push_back(neighborState);
                    microchips[1] = j;
                    if (takeItem(state, generators, 0, microchips, 2, elevator, neighborState))
                        results.push_back(neighborState);
                }
                for (int j = 0; j < stateLength; j++) {
                    microchips[0] = j;
                    if (takeItem(state, generators, 1, microchips, 1, elevator, neighborState))
                        results.push_back(neighborState);
                }
            }
        }
        return results;
    }

    bool isGoal(const State& state) {
        if (state.elevator != 3)
            return false;
        for (int i = 0; i < stateLength; i++) {
            if (state.generators[i] != 3 || state.microchips[i] != 3)
                return false;
        }
        return true;
    }

    bool isValid(const State& state) {
        for (int i = 0; i < stateLength; i++) {
            int microchipFloor = state.microchips[i];
            if (microchipFloor == state.generators[i])
                continue;
            for (int j = 0; j < stateLength; j++) {
                if (i == j)
                    continue;
                if (microchipFloor == state.generators[i])
                    return false;
            }
        }
        return true;
    }

public:
    Solver(int stateLength) : stateLength(stateLength) { }

    int bfs(const State& initialState) {
        std::queue<std::tuple<State, int>> queue;
        std::unordered_set<State> visited;
        queue.push(std::make_tuple(initialState, 0));
        while (!queue.empty()) {
            State current;
            int steps;
            std::tie(current, steps) = queue.front();
            queue.pop();
            if (visited.find(current) != visited.end())
                continue;
            visited.insert(current);
            if (isGoal(current))
                return steps;
            std::vector<State> neighbors = neighborStates(current);
            for (const auto& neighbor : neighbors) {
                if (!isValid(neighbor))
                    continue;
                if (visited.find(neighbor) == visited.end()) 
                    queue.push(std::make_tuple(neighbor, steps + 1));
            }
        }
        return -1;
    }
};

void print(const State& state, const StateInfo& info) {
    for (int i = 0; i < info.names.size(); i++) {
        std::cout << info.names[i] << std::endl;
        std::cout << "gen " << (int)state.generators[i] << std::endl;
        std::cout << "micro " << (int)state.microchips[i] << std::endl;
    }
}

int main() {
    State state;
    StateInfo info;
    std::tie(state, info) = readInput();
    std::string a;
    Solver solver(info.names.size());
    int steps = solver.bfs(state);
    std::cout << "STEPS: " << steps << std::endl;
    return 0;
}
