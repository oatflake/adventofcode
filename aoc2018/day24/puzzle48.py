class Group:
    def __init__(self, units, hitPoints, attackStrength, attackType, initiative, weaknesses, immunities):
        self.units = units
        self.hitPoints = hitPoints
        self.attackStrength = attackStrength
        self.attackType = attackType
        self.initiative = initiative
        self.weaknesses = set(weaknesses)
        self.immunities = set(immunities)

    def effectivePower(self):
        return self.units * self.attackStrength
    
    def chooseTarget(self, targets):
        chosenTarget = None
        for target in targets:
            if self.attackType in target.immunities:
                continue
            if chosenTarget == None:
                chosenTarget = target
                continue
            weakTarget = self.attackType in target.weaknesses
            weakChosenTarget = self.attackType in chosenTarget.weaknesses
            if weakTarget and not weakChosenTarget:
                chosenTarget = target
            elif weakTarget == weakChosenTarget:
                if target.effectivePower() > chosenTarget.effectivePower():
                    chosenTarget = target
                elif target.effectivePower() == chosenTarget.effectivePower():
                    if target.initiative > chosenTarget.initiative:
                        chosenTarget = target
        return chosenTarget

    def attack(self, otherGroup):
        damage = self.effectivePower()
        if self.attackType in otherGroup.weaknesses:
            damage *= 2
        otherGroup.units -= damage // otherGroup.hitPoints
        
def chooseTargets(army1, army2):
    attackers = sorted(army1, key = lambda x: (x.effectivePower(), x.initiative), reverse=True)
    targets = set(army2)
    chosenTargets = dict()
    for attacker in attackers:
        target = attacker.chooseTarget(targets)
        if target != None:
            targets.remove(target)
        chosenTargets[attacker] = target
    return chosenTargets

def targetChoosingPhase(immuneSystem, infection):
    chosenTargets = chooseTargets(immuneSystem, infection)
    chosenTargets.update(chooseTargets(infection, immuneSystem))
    return chosenTargets

def attackPhase(immuneSystem, infection, chosenTargets):
    groups = sorted(immuneSystem + infection, key = lambda x: x.initiative, reverse=True)
    for group in groups:
        if group.units <= 0:
            continue
        target = chosenTargets[group]
        if target != None:
            group.attack(target)
    for group in groups:
        if group.units <= 0:
            if group in immuneSystem:
                immuneSystem.remove(group)
            if group in infection:
                infection.remove(group)

def totalUnits(immuneSystem, infection):
    immuneSystemUnits = 0
    for group in immuneSystem:
        immuneSystemUnits += group.units
    infectionUnits = 0
    for group in infection:
        infectionUnits += group.units
    return (immuneSystemUnits, infectionUnits)

def fight(immuneSystem, infection):
    units = totalUnits(immuneSystem, infection)
    while len(immuneSystem) > 0 and len(infection) > 0:
        chosenTargets = targetChoosingPhase(immuneSystem, infection)
        attackPhase(immuneSystem, infection, chosenTargets)
        newUnits = totalUnits(immuneSystem, infection)
        if units == newUnits:
            return -1
        units = newUnits
    survivors = 0
    for group in immuneSystem:
        survivors += group.units
    return survivors

def readInput():
    immuneSystem = []
    infection = []
    army = None
    input = open("input", "r")
    for line in input:
        if line == "\n":
            continue
        if line == "Immune System:\n":
            army = immuneSystem
            continue
        if line == "Infection:\n":
            army = infection
            continue
        weaknesses = []
        immunities = []
        attributesStart = line.find("(")
        if attributesStart != -1:
            attributesEnd = line.find(")")
            attributes = line[attributesStart + 1:attributesEnd]
            attributes = attributes.split("; ")
            for attribute in attributes:
                if attribute.startswith("weak"):
                    weaknesses = attribute[len("weak to "):]
                    weaknesses = weaknesses.split(", ")
                if attribute.startswith("immune"):
                    immunities = attribute[len("immune to "):]
                    immunities = immunities.split(", ")
            line = line[:attributesStart] + line[attributesEnd + 2:]
        line = line.split(" ")
        units = int(line[0])
        hitPoints = int(line[4])
        attackStrength = int(line[12])
        attackType = line[13]
        initiative = int(line[-1])
        army.append(Group(units, hitPoints, attackStrength, attackType, initiative, weaknesses, immunities))
    return immuneSystem, infection

def boostedFight(boost):
    immuneSystem, infection = readInput()
    for group in immuneSystem:
        group.attackStrength += boost
    return fight(immuneSystem, infection)

def main():
    rangeStart = 0
    rangeEnd = 1 << 20
    boost = (rangeStart + rangeEnd) // 2
    survivors = boostedFight(boost)
    while not (boostedFight(boost - 1) <= 0 and survivors > 0):
        if survivors > 0:
            rangeEnd = boost - 1
        else:
            rangeStart = boost + 1
        boost = (rangeStart + rangeEnd) // 2
        survivors = boostedFight(boost)
    print survivors
    
main()