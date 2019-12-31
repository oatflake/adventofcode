// needs compilation with g++ puzzle9.cpp -lcrypto
#include <cstring>
#include <string.h>
#include <iostream>
#include "openssl/md5.h"
#include <stdio.h>
#include <unordered_set>
#include <string>
#include <queue>
#include <cmath>

// -------- based on https://biicode-docs.readthedocs.io/c++/examples/openssl.html --------
std::string md5(const std::string& word) {
    unsigned char digest[MD5_DIGEST_LENGTH];
    MD5((unsigned char*)word.c_str(), strlen(word.c_str()), (unsigned char*)&digest);    
    char mdString[33];
    for(int i = 0; i < 16; i++)
         sprintf(&mdString[i*2], "%02x", (unsigned int)digest[i]);
    return std::string(mdString);
}
// ----------------------------------------------------------------------------------------

int count(const std::string& word, char c) {
    int n = 0;
    for (int i = word.size() - 1; i >= 0; i--) {
        if (word[i] == c)
            n++;
    }
    return n;
}

int coords(const std::string& path, int& x, int& y) {
    x = count(path, 'R') - count(path, 'L');
    y = count(path, 'D') - count(path, 'U');
}

bool validCoord(int x, int y) {
    return x >= 0 && x < 4 && y >= 0 && y < 4;
}

bool validHash(char c) {
    return c >= 'b' && c <= 'f';
}

void neighbors(const std::string& input, const std::string& path, int x, int y, 
    char (&directions)[4], int& validDirections) 
{
    validDirections = 0;
    std::string hash = md5(input + path);
    if (validHash(hash[0]) && y > 0) {
        directions[validDirections++] = 'U';
    }
    if (validHash(hash[1]) && y < 3) {
        directions[validDirections++] = 'D';
    }
    if (validHash(hash[2]) && x > 0) {
        directions[validDirections++] = 'L';
    }
    if (validHash(hash[3]) && x < 3) {
        directions[validDirections++] = 'R';
    }
}

bool isGoal(int x, int y) {
    return x == 3 && y == 3;
}

int bfs(const std::string input) {
    std::queue<std::string> queue;
    queue.push("");
    int x;
    int y;
    char directions[4];
    int validDirections;
    long unsigned int maxPathLength = 0;
    while (!queue.empty()) {
        std::string current = queue.front();
        queue.pop();
        coords(current, x, y);
        if (isGoal(x, y)) {
            maxPathLength = std::max(maxPathLength, current.size());
            continue;
        }
        neighbors(input, current, x, y, directions, validDirections);
        for (int i = 0; i < validDirections; i++) {
            queue.push(current + directions[i]);
        }
    }
    return maxPathLength;
}

int main() {
    std::string input = "pxxbnzuo";
    std::cout << bfs(input) << std::endl;
    return 0;
}
