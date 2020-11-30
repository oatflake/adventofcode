#include <iostream>
#include <string>
#include <vector> 
#include <unordered_set>
#include <algorithm>
#include "../helper.h"

int main() {
    int count = 0;    
    auto lambda = [&](const std::string& line) {
        std::unordered_set<std::string> seen;
        auto words = split(line, " ");
        for (auto word : words) {
            std::sort(word.begin(), word.end());
            if (seen.find(word) != seen.end())  
                return;
            seen.insert(word);
        }
        count++;
    };
    readInputFile(lambda);
    std::cout << count << std::endl;
    return 0;
}
