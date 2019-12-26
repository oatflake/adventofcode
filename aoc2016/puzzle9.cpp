// needs compilation with g++ puzzle9.cpp -lcrypto
#include <cstring>
#include <string.h>
#include <iostream>
#include "openssl/md5.h"
#include <stdio.h>

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

int main() {
    int index = 0;
    std::string input = "ugkcyxxp";
    int foundHashes = 0;
    std::string result;
    while (foundHashes < 8) {
        std::string hash = md5(input + std::to_string(index));
        bool ok = true;
        for (int i = 0; i < 5; i++) {
            if (hash[i] != '0') {
                ok = false;
                break;
            }
        }
        if (ok) {
            result += hash[5];
            foundHashes++;
        }
        index++;
    }
    std::cout << result << std::endl;
    return 0;
}
