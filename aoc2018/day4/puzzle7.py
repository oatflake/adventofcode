import datetime

class Event:
    def __init__(self, date, type, id):
        self.date = date
        self.type = type
        self.id = id

# sort input data
events = []
input = open("input", "r")
for line in input:
    split = line.split(' ')
    dateString = split[0].split('-')
    year = int(dateString[0][1:])
    month = int(dateString[1])
    day = int(dateString[2])
    timeString = split[1].split(':')
    hour = int(timeString[0])
    minute = int(timeString[1][:-1])
    date = datetime.datetime(year,month,day,hour,minute)
    type = -1
    if split[2] == "Guard":
        type = 'b'
    if split[2] == "falls":
        type = 'f'
    if split[2] == "wakes":
        type = 'w'
    id = -1
    if type == 'b':
        id = int(split[3][1:])
    events.append(Event(date, type, id))
events = sorted(events, key = lambda event: event.date)

# find guard with most minutes asleep
currentID = -1
timeStampFellAsleep = None
guards = dict()
for event in events:
    if event.type == 'b':
        if timeStampFellAsleep != None:
            print("ERROR: Guard asleep on shift change!")
        currentID = event.id
        if not event.id in guards:
            guards[event.id] = 0
    event.id = currentID
    if event.type == 'f':
        timeStampFellAsleep = event.date
    if event.type == 'w':
        guards[event.id] += (event.date - timeStampFellAsleep).seconds / 60
        timeStampFellAsleep = None
maxTime = -1
maxID = -1
for id in guards:
    if guards[id] > maxTime:
        maxID = id
        maxTime = guards[id]

# find minute during which the guard is asleep most often
minutes = [0] * 60
startTime = -1
for event in events:
    if event.id == maxID:
        if event.type == 'f':
            startTime = event.date.minute
        if event.type == 'w':
            for i in range(startTime, event.date.minute + 1):
                minutes[i] += 1
maxMinute = -1
maxAsleep = -1
for i in range(len(minutes)):
    if minutes[i] > maxAsleep:
        maxAsleep = minutes[i]
        maxMinute = i

# result
print maxID * maxMinute
