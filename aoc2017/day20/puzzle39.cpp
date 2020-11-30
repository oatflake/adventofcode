#include <iostream>
#include <string>
#include <vector>
#include <limits>
#include <algorithm>
#include "../helper.h"

struct Particle {
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

bool compareParticles (const Particle& a, const Particle& b) { 
    int64_t aAccel = Vector<int64_t, 3>::dot(a.acceleration, a.acceleration);
    int64_t bAccel = Vector<int64_t, 3>::dot(b.acceleration, b.acceleration);
    if (aAccel > bAccel)
        return true;
    if (aAccel < bAccel)
        return false;
    int64_t aVel = Vector<int64_t, 3>::dot(a.velocity, a.velocity);
    int64_t bVel = Vector<int64_t, 3>::dot(b.velocity, b.velocity);
    if (aVel > bVel)
        return true;
    if (aVel < bVel)
        return false;
    int64_t aPos = Vector<int64_t, 3>::dot(a.position, a.position);
    int64_t bPos = Vector<int64_t, 3>::dot(b.position, b.position);
    if (aPos > bPos)
        return true;
    if (aPos < bPos)
        return false;
    return false;
}

int main() {
    auto particles = readInput();
    bool movingCloser = true;
    /** 
     * Worked, but the logic is faulty: 
     * We need to check in which direction the acceleration is pointing!
     * Otherwise we might move away from the origin with a high velocity,
     * but later on might change direction due to a low acceleration pointing in the opposite diection.
     * Therefore we could start to move towards the origin at a later point in time!
     * We currently miss this case.
     **/
    while (movingCloser) {
        movingCloser = false;
        for (auto& particle : particles) {
            int64_t d1 = Vector<int64_t, 3>::dot(particle.position, particle.position);
            particle.velocity = particle.velocity + particle.acceleration;
            particle.position = particle.position + particle.velocity;
            int64_t d2 = Vector<int64_t, 3>::dot(particle.position, particle.position);
            if (d1 > d2)
                movingCloser = true;
        }
    }
    std::sort (particles.begin(), particles.end(), compareParticles);
    std::cout << particles[particles.size()-1].id << std::endl;
    return 0;
}
