#include <string>
#include <iostream>
#include "helper.h"

void scramble(std::string& password) {
    std::string copy = password;
    auto lambda = [&](void*, const std::string& line) {
        auto parts = split(line, " ");
        if (parts[0] == "move") {
            int from = std::stoi(parts[2]);
            int to = std::stoi(parts[5]);
            char c = password[from];
            password.erase(from, 1);
            password.insert(to, 1, c);
        }
        else if (parts[1] == "letter") {    // swap
            int from = password.find(parts[2]);
            int to = password.find(parts[5]);
            char c = password[from];
            password[from] = password[to];
            password[to] = c;
        }
        else if (parts[1] == "right") {      // rotate
            copy = password;
            int amount = std::stoi(parts[2]) % password.size();
            for (int i = 0; i < password.size(); i++) {
                password[i] = copy[(password.size() - amount + i) % password.size()];
            }
        }
        else if (parts[1] == "left") {     // rotate
            copy = password;
            int amount = std::stoi(parts[2]) % password.size();
            for (int i = 0; i < password.size(); i++) {
                password[i] = copy[(password.size() + amount + i) % password.size()];
            }
        }
        else if (parts[1] == "based") {     // rotate
            copy = password;
            int i = password.find(parts[6]);
            int amount = (1 + i + (i >= 4 ? 1 : 0)) % password.size();
            for (int i = 0; i < password.size(); i++) {
                password[i] = copy[(password.size() - amount + i) % password.size()];
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
            int from = std::stoi(parts[2]);
            int to = std::stoi(parts[5]);
            char c = password[from];
            password[from] = password[to];
            password[to] = c;
        }
    };
    readInputFile(nullptr, lambda);
}

int main() {
    std::string password = "abcdefgh";
    scramble(password);
    std::cout << password << std::endl;
    return 0;
}
