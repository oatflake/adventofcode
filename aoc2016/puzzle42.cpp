#include <string>
#include <vector>
#include <iostream>
#include "helper.h"

void scramble(std::string& password) {
    std::string copy = password;
    std::vector<std::string> lines;
    auto lambda = [&](void*, const std::string& line) {
        lines.push_back(line);
    };
    readInputFile(nullptr, lambda);
    for (int j = lines.size() - 1; j >= 0; j--) {
        auto parts = split(lines[j], " ");
        if (parts[0] == "move") {
            int from = std::stoi(parts[5]);
            int to = std::stoi(parts[2]);
            char c = password[from];
            password.erase(from, 1);
            password.insert(to, 1, c);
        }
        else if (parts[1] == "letter") {    // swap
            int from = password.find(parts[5]);
            int to = password.find(parts[2]);
            char c = password[from];
            password[from] = password[to];
            password[to] = c;
        }
        else if (parts[1] == "left") {      // rotate
            copy = password;
            int amount = std::stoi(parts[2]) % password.size();
            for (int i = 0; i < password.size(); i++) {
                password[i] = copy[(password.size() - amount + i) % password.size()];
            }
        }
        else if (parts[1] == "right") {     // rotate
            copy = password;
            int amount = std::stoi(parts[2]) % password.size();
            for (int i = 0; i < password.size(); i++) {
                password[i] = copy[(password.size() + amount + i) % password.size()];
            }
        }
        else if (parts[1] == "based") {     // rotate
            copy = password;
            int i = password.find(parts[6]);
            int k = 0;
            while (true) { 
                int amount = (1 + k + (k >= 4 ? 1 : 0)) % password.size();
                if (i % password.size() == (amount + k) % password.size())
                    break;
                k++;
            }
            int amount = (1 + k + (k >= 4 ? 1 : 0)) % password.size();
            for (int i = 0; i < password.size(); i++) {
                password[i] = copy[(password.size() + amount + i) % password.size()];
            }
        }
        else if (parts[0] == "reverse") {
            int from = std::stoi(parts[2]);
            int to = std::stoi(parts[4]) + 1;
            for (int i = from; i < (to + from) / 2; i++) {
                char c = password[i];
                password[i] = password[to - i - 1 + from];
                password[to - i + from - 1] = c;
            }
        }
        else if (parts[1] == "position") {  // swap
            int from = std::stoi(parts[5]);
            int to = std::stoi(parts[2]);
            char c = password[from];
            password[from] = password[to];
            password[to] = c;
        }
    }
}

int main() {
    std::string password = "fbgdceah";
    scramble(password);
    std::cout << password << std::endl;
    return 0;
}
