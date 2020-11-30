#include <iostream>
#include <vector>
#include <string>
#include "../helper.h"

std::vector<std::string> readFile() {
    std::vector<std::string> lines;
std::string input =
"cpy a b\n\
dec b\n\
cpy a d\n\
mul b d a\n\
nop b c\n\
nop a\n\
nop c\n\
nop c -2\n\
nop d\n\
nop d -5\n\
dec b\n\
cpy b c\n\
cpy c d\n\
dec d\n\
inc c\n\
jnz d -2\n\
tgl c\n\
cpy -16 c\n\
jnz 1 c\n\
cpy 74 c\n\
jnz 88 d\n\
inc a\n\
inc d\n\
jnz d -2\n\
inc c\n\
jnz c -5";
    lines = split(input, "\n");
    return lines;
}

int main() {
    auto lines = readFile();
    int registers[4] = { 12, 0, 0, 0 };
    int instruction = 0;
    while (instruction < lines.size()) {
        auto parts = split(lines[instruction++], " ");
        if (parts[0] == "cpy") {
            int value;
            if ('a' > parts[2][0] || parts[2][0] > 'd')
                continue;
            if ('a' <= parts[1][0] && parts[1][0] <= 'd')
                 value = registers[parts[1][0] - 'a'];
            else
                 value = std::stoi(parts[1]);
            registers[parts[2][0] - 'a'] = value;
        } else if (parts[0] == "inc") {
            registers[parts[1][0] - 'a']++;
        } else if (parts[0] == "dec") {
            registers[parts[1][0] - 'a']--;
        } else if (parts[0] == "jnz") {
            int value;
            int value2;
            if ('a' <= parts[1][0] && parts[1][0] <= 'd')
                value = registers[parts[1][0] - 'a'];
            else
                value = std::stoi(parts[1]);
            if ('a' <= parts[2][0] && parts[2][0] <= 'd')
                value2 = registers[parts[2][0] - 'a'];
            else
                value2 = std::stoi(parts[2]);
            if (value != 0)
                instruction += value2 - 1;
        } else if (parts[0] == "tgl") {
            int value;
            if ('a' <= parts[1][0] && parts[1][0] <= 'd')
                value = registers[parts[1][0] - 'a'];
            else
                value = std::stoi(parts[1]);
            int modifiedInstruction = instruction + value - 1;
            if (modifiedInstruction >= lines.size())
                continue;
            auto tglParts = split(lines[modifiedInstruction], " ");
            if (tglParts.size() == 2) {
                if (tglParts[0] == "inc")
                    lines[modifiedInstruction].replace(0, 3, "dec");
                else
                    lines[modifiedInstruction].replace(0, 3, "inc");
            } else if (tglParts.size() == 3) {
                if (tglParts[0] == "jnz")
                    lines[modifiedInstruction].replace(0, 3, "cpy");
                else
                    lines[modifiedInstruction].replace(0, 3, "jnz");
            }
        } else if (parts[0] == "mul") {
            int value = registers[parts[1][0] - 'a'];
            int value2 = registers[parts[2][0] - 'a'];
            registers[parts[3][0] - 'a'] = value * value2;
        }
    }
    std::cout << registers[0] << std::endl;
    return 0;
}
