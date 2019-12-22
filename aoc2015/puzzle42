def readInput():
    input = open("input", "r")
    bossHitPoints = -1
    bossDamage = -1
    bossArmor = -1
    for line in input:
        if line.startswith("Hit Points"):
            bossHitPoints = line.strip("\n").split(" ")[-1]
        if line.startswith("Damage"):
            bossDamage = line.strip("\n").split(" ")[-1]
        if line.startswith("Armor"):
            bossArmor = line.strip("\n").split(" ")[-1]
    return int(bossHitPoints), int(bossDamage), int(bossArmor)

def winsFight(player, boss):
    bossHP = boss[0]
    playerHP = player[0]
    while True:
        bossHP -= max(player[1] - boss[2], 1)
        if bossHP <= 0:
            return True
        playerHP -= max(boss[1] - player[2], 1)
        if playerHP <= 0:
            return False

boss = readInput()
weapons = [(8, 4), (10, 5), (25, 6), (40, 7), (74, 8)]
armors = [(13, 1), (31, 2), (53, 3), (75, 4), (102, 5)]
rings = [(25, 1, 0), (50, 2, 0), (100, 3, 0), (20, 0, 1), (40, 0, 2), (80, 0, 3)]

playerHitPoints = 100
equipments = []
for weapon in weapons:
    equipments.append((weapon[0], weapon[1], 0))
equipmentsCopy = equipments[:]
for armor in armors:
    for equipment in equipmentsCopy:
        equipments.append((equipment[0] + armor[0], equipment[1], equipment[2] + armor[1]))
equipmentsCopy = equipments[:]
for i in range(len(rings)):
    for equipment in equipmentsCopy:
        newEquipment = (equipment[0] + rings[i][0], equipment[1] + rings[i][1], equipment[2] + rings[i][2])
        equipments.append(newEquipment)
        for j in range(i + 1, len(rings)):
            equipments.append((newEquipment[0] + rings[j][0], newEquipment[1] + rings[j][1], newEquipment[2] + rings[j][2]))

equipments = filter(lambda e: not winsFight((playerHitPoints, e[1], e[2]), boss), equipments)
print reduce(lambda e1, e2: e1 if e1[0] > e2[0] else e2, equipments)[0]
