#include <iostream>
#include <string>
#include <map>
#include <vector>
#include <queue>
#include <math.h>
#include "../helper.h"

int64_t read(const std::string& input, std::map<char, int64_t>& registers) {
    if (input[0] >= 'a' && input[0] <= 'z') {
        if (registers.find(input[0]) != registers.end())
            return registers[input[0]];
        return 0;
    }
    return std::stoi(input);
}

std::vector<std::string> readInput() {
    std::vector<std::string> instructions;
    auto lambda = [&](const std::string& line) {
        instructions.push_back(line);
    };
    readInputFile(lambda);
    return instructions;
}

enum State {
    RUNNING,
    TERMINATED
};

class Computer {
    std::map<char, int64_t> registers;
    std::vector<std::string> instructions;
    int64_t instructionPointer = 0;
    int64_t multiplications = 0;
public:
    Computer(std::vector<std::string> instructions) : instructions(instructions) { 
        //registers['a'] = 1;
    }

    std::tuple<State, int64_t> execute() {
        if (instructionPointer >= instructions.size() || instructionPointer < 0) {
            int64_t m = multiplications;
            return std::make_tuple<State, int64_t>(State::TERMINATED, std::move(m));
        }
        auto parts = split(instructions[instructionPointer++], " ");
        if (parts[0] == "set"){
            int64_t value = read(parts[2], registers);
            registers[parts[1][0]] = value;
        }
        if (parts[0] == "sub"){
            int64_t value = read(parts[2], registers);
            registers[parts[1][0]] = read(parts[1], registers) - value;
        }
        if (parts[0] == "mul"){
            int64_t value = read(parts[2], registers);
            multiplications++;
            registers[parts[1][0]] = read(parts[1], registers) * value;
        }
        if (parts[0] == "jnz"){
            int64_t value = read(parts[2], registers);
            if (read(parts[1], registers) != 0)
                instructionPointer += value - 1;
        }
        return std::make_tuple<State, int64_t>(State::RUNNING, 0);
    }

    void printRegisters() {
        std::cout << instructionPointer << "\t";
        for (auto iter = registers.begin(); iter != registers.end(); iter++) {
            std::cout << iter->first << " " << iter->second << " ";
        }
        std::cout << std::endl;
    }
};
/*
int main() {
    auto instructions = readInput();
    Computer computer(instructions);
    bool end = false;
    int64_t result;
    while (!end) {
        State state;
        std::tie(state, result) = computer.execute();
        if (state == State::TERMINATED)
            end = true;
        computer.printRegisters();
    }
    std::cout << result << std::endl;
    return 0;
}*/

bool isPrime(int n) {
    for (int i = 2; i < int(sqrt(n) + 1); i++) {
        if (n % i == 0)
            return false;
        }
    return true;
}

int main() {
    // the following is used to test our hypothesis of what the input code is computing. The result is 9.
    //int b = 10;
    //int c = 180;
    int b = 106500;
    int c = 123500;
    int h = 0;
    while (b <= c) {
        if (!isPrime(b))
            h += 1;
        b += 17;
    }
    std::cout << h << std::endl;
}


/**
 * So here's what's happening:
 * For all  d,e  less than  b  it is checked whether there are  d,e  such that  d * e == b
 * In other words, it is checked whether  b  is not a prime number. 
 * If so, then f is set to 0. Afterwards  h  is increased by 1 if  f  is 0.
 * That is to say, we count the number of non primes.
 * Then  b  is increased by 17, until  b == c.
 * So we count non-primes in the range  b  to  c  such that these numbers are   rangeBegin + 17 * x <= rangeEnd.
 * When the register  a  is set to 1, the value range is initialized using registers b and c:
 * b = 106500
 * c = 123500
 * By letting  a  remain 0 and manipulating the input, we can set  b  and  c  to small values in order to 
 * check our hypothesis and compare that to our prime number counting code. The following results in  h = 9:

set b 10
set c 180
jnz a 2
jnz 1 5
mul b 100
sub b -100000
set c b
sub c -17000
set f 1
set d 2
set e 2
set g d
mul g e
sub g b
jnz g 2
set f 0
sub e -1
set g e
sub g b
jnz g -8
sub d -1
set g d
sub g b
jnz g -13
jnz f 2
sub h -1
set g b
sub g c
jnz g 2
jnz 1 3
sub b -17
jnz 1 -23

 * 
 **/