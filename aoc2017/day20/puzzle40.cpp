#include <iostream>
#include <string>
#include <vector>
#include <limits>
#include <algorithm>
#include <unordered_map>
#include "../helper.h"

struct Particle {
    bool alive = true;
    int id;
    Vector<int64_t,  3> position;
    Vector<int64_t,  3> velocity;
    Vector<int64_t,  3> acceleration;
    Particle(int id, Vector<int64_t,  3> position, Vector<int64_t,  3> velocity, Vector<int64_t,  3> acceleration) : 
        id(id), position(position), velocity(velocity), acceleration(acceleration) { }
};

std::vector<Particle> readInput() {
    std::vector<Particle> particles;
    int id = 0;
    auto lambda = [&](const std::string& line) {
        auto parts = split(line, ", ");
        auto pos = split(parts[0].substr(3, parts[0].size() - 4), ",");
        auto vel = split(parts[1].substr(3, parts[1].size() - 4), ",");
        auto accel = split(parts[2].substr(3, parts[2].size() - 4), ",");
        int64_t p[] = {std::stoi(pos[0]), std::stoi(pos[1]), std::stoi(pos[2])};
        int64_t v[] = {std::stoi(vel[0]), std::stoi(vel[1]), std::stoi(vel[2])};
        int64_t a[] = {std::stoi(accel[0]), std::stoi(accel[1]), std::stoi(accel[2])};
        particles.push_back(Particle(id++, Vector<int64_t, 3>(p), Vector<int64_t, 3>(v), Vector<int64_t, 3>(a)));
    };
    readInputFile(lambda);
    return particles;
}

int main() {
    auto particles = readInput();
    for (int j = 0; j < 1000; j++) {
        std::unordered_map<Vector<int64_t, 3>, std::vector<int>> posMappedParticles;
        for (int i = 0; i < particles.size(); i++) {
            auto& particle = particles[i];
            if (!particle.alive)
                continue;
            particle.velocity = particle.velocity + particle.acceleration;
            particle.position = particle.position + particle.velocity;
            auto iter = posMappedParticles.find(particle.position);
            if (iter != posMappedParticles.end())
                iter->second.push_back(particle.id);
            else {
                std::vector<int> ids;
                ids.push_back(particle.id);
                posMappedParticles[particle.position] = ids;
            }
        }
        for (auto& iter : posMappedParticles) {
            if (iter.second.size() > 1) {
                for (int id : iter.second)
                    particles[id].alive = false;
            }
        }
    }
    int alive = 0;
    for (auto& particle : particles)
        alive += particle.alive ? 1 : 0;
    std::cout << alive << std::endl;
    return 0;
}
