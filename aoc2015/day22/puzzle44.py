from enum import Enum
from heapq import heappush, heappop

debug = False

class Turn(Enum):
    PLAYER = 0,
    BOSS = 1

class State:
    def __init__(self, bossHitPoints, bossDamage, playerHitPoints, playerMana):
        self.bossHitPoints = bossHitPoints
        self.bossDamage = bossDamage
        self.playerHitPoints = playerHitPoints
        self.playerMana = playerMana
        self.playerArmor = 0
        self.shieldTimer = 0
        self.poisonTimer = 0
        self.rechargeTimer = 0
        self.turn = Turn.PLAYER
    
    def copy(self):
        state = State(self.bossHitPoints, self.bossDamage, self.playerHitPoints, self.playerMana)
        state.playerArmor = self.playerArmor
        state.shieldTimer = self.shieldTimer
        state.poisonTimer = self.poisonTimer
        state.rechargeTimer = self.rechargeTimer
        state.turn = self.turn
        return state

    def nextTurn(self):
        newState = self.copy()
        newState.turn = Turn.PLAYER if self.turn == Turn.BOSS else Turn.BOSS
        if newState.turn == Turn.PLAYER:
            newState.playerHitPoints -= 1
        if debug:
            newState.display()
        if self.shieldTimer > 0:
            newState.shieldTimer -= 1
            newState.playerArmor = 7 if newState.shieldTimer > 0 else 0
            if debug:
                print "Shield's timer is now", newState.shieldTimer
        if self.poisonTimer > 0:
            newState.poisonTimer -= 1
            newState.bossHitPoints -= 3
            if debug:
                print "Poison deals 3 damage; its timer is now", newState.poisonTimer
        if self.rechargeTimer > 0:
            newState.rechargeTimer -= 1
            newState.playerMana += 101
            if debug:
                print "Recharge provides 101 mana; its timer is now", newState.rechargeTimer
        return newState

    def display(self):
        print ""
        print self.turn
        print "Player has", self.playerHitPoints, "hit points", \
            self.playerArmor, "armor", self.playerMana, "mana"
        print "Boss has", self.bossHitPoints, "hit points"

def bossAction(state):
    damage = max(1, state.bossDamage - state.playerArmor)
    if debug:
        print "Boss attacks for", state.bossDamage, "-", state.playerArmor, "=", damage, "damage!"
    newState = state.copy()
    newState.playerHitPoints -= damage
    return newState

def castMagicMissile(state):
    if debug:
        print "Player casts Magic Missile, dealing 4 damage."
    newState = state.copy()
    newState.bossHitPoints -= 4
    newState.playerMana -= 53
    return newState

def castDrain(state):
    if debug:
        print "Player casts Drain, dealing 2 damage, and healing 2 hit points."
    newState = state.copy()
    newState.bossHitPoints -= 2
    newState.playerHitPoints += 2
    newState.playerMana -= 73
    return newState

def castShield(state):
    if debug:
        print "Player casts Shield, increasing armor by 7."
    newState = state.copy()
    newState.shieldTimer = 6
    newState.playerMana -= 113
    return newState

def castPoison(state):
    if debug:
        print "Player casts Poison."
    newState = state.copy()
    newState.poisonTimer = 6
    newState.playerMana -= 173
    return newState

def castRecharge(state):
    if debug:
        print "Player casts Recharge."
    newState = state.copy()
    newState.rechargeTimer = 5
    newState.playerMana -= 229
    return newState

def play(initialState):
    if debug:
        initialState.display()
    heap = []
    heappush(heap, (0, initialState))
    while len(heap) > 0:
        mana, currentState = heappop(heap)
        if currentState.playerHitPoints <= 0 or currentState.playerMana <= 0:
            continue
        if currentState.bossHitPoints <= 0:
            if debug:
                currentState.display()
            print mana
            break
        if currentState.turn == Turn.PLAYER:
            heappush(heap, (mana + 73, castDrain(currentState).nextTurn()))
            heappush(heap, (mana + 53, castMagicMissile(currentState).nextTurn()))
            if currentState.poisonTimer == 0:
                heappush(heap, (mana + 173, castPoison(currentState).nextTurn()))
            if currentState.rechargeTimer == 0:
                heappush(heap, (mana + 229, castRecharge(currentState).nextTurn()))
            if currentState.shieldTimer == 0:
                heappush(heap, (mana + 113, castShield(currentState).nextTurn()))
        else:
            heappush(heap, (mana, bossAction(currentState).nextTurn()))

def main():
    input = open("input", "r")
    bossHitPoints = int(input.readline().strip().split(" ")[2])
    bossDamage = int(input.readline().strip().split(" ")[1])
    playerMana = 500
    playerHitPoints = 50
    initialState = State(bossHitPoints, bossDamage, playerHitPoints - 1, playerMana)
    play(initialState)

main()