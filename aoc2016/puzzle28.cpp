// needs compilation with g++ puzzle9.cpp -lcrypto
#include <cstring>
#include <string.h>
#include <iostream>
#include "openssl/md5.h"
#include <stdio.h>
#include <vector>
#include <unordered_set>

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

const std::string input = "zpqevtbw";

void searchLetterSequences(const std::string& hash, std::unordered_set<char>& letters, int length, bool onlyFirst) {
    letters.clear();
    for (int i = 0; i < hash.size() - length + 1; i++) {
        int c = i;
        char chr = hash[c];
        bool match = true;
        for (i = c + 1; i < c + length; i++) {
            if (hash[i] != chr) {
                match = false;
                break;
            }
        }
        i--;
        if (match) {
            letters.insert(chr);
            if (onlyFirst)
                break;
        }
    }
}

int hexIndex(char c) {
    return std::isdigit(c) ? c - '0' : c - 'a' + 10;
}

int main() {
    int fiveLetterOccurences[16];
    int saltIndex = 0;
    std::string ringBuffer[1000];
    int bufferIndex = 0;
    std::unordered_set<char> letterSet;
    for (int i = 0; i < 1000; i++) {
        std::string hash = md5(input + std::to_string(saltIndex++));
        for (int j = 0; j < 2016; j++) {
            hash = md5(hash);
        }
        ringBuffer[bufferIndex++] = hash;
        searchLetterSequences(hash, letterSet, 5, false);
        for (const auto& chr : letterSet) {
            fiveLetterOccurences[hexIndex(chr)]++;
        }
    }
    bufferIndex = 0;
    int validHashes = 0;
    while (validHashes < 64) {
        std::string hash = md5(input + std::to_string(saltIndex++));
        for (int j = 0; j < 2016; j++) {
            hash = md5(hash);
        }
        std::string oldHash = ringBuffer[bufferIndex];
        ringBuffer[bufferIndex++] = hash;
        bufferIndex %= 1000;
        searchLetterSequences(hash, letterSet, 5, false);
        for (const auto& chr : letterSet) {
            fiveLetterOccurences[hexIndex(chr)]++;
        }
        searchLetterSequences(oldHash, letterSet, 5, false);
        for (const auto& chr : letterSet) {
            fiveLetterOccurences[hexIndex(chr)]--;
        }
        bool valid = false;
        searchLetterSequences(oldHash, letterSet, 3, true);
        for (const auto& chr : letterSet) {
            if (fiveLetterOccurences[hexIndex(chr)] > 0) {
                valid = true;
                break;
            }
        }
        if (valid) 
            validHashes++;
    }
    std::cout << saltIndex - 1001 << std::endl;
    return 0;
}
