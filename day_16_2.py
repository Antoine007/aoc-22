# taken from https://topaz.github.io/paste/#XQAAAQAWCgAAAAAAAAA0m0pnuFI8c9q4WY2s1odXNfK+yGH/+0Y2nkvXqOxvHxM1VEPDSbyMATQ1TNDf9Y8VIpOiQxtcOGIO5eStgG3MIA8XXCGEeIqebTZGdHR1gJ+8LIjY7o11ReZHUXEwoeMV/J9/pSgQs1wSoi+zduK0w2vQCoqxKc3/5eL3TzloNOhNgRnfStkasm4+xJwchZT3ywepABoU7D/rVFKhbdYMmQXpm5ROGbL/8Vtln2tMEBC+/Q/uzYKFUjXL3l1/vngSD1eWInre/ra7wpJZrj7+NONjkFqfshbhscom4FlfPN9GO0G0qnfSJKokTRecOv3k7arWeLKRxy3SzubPsPVzkT6xVZhjAHZQ8aIyB/U8QvconCQoNKbyLT6SvPtam4n3eVQsdLBmgex+zFSTbkYnvIUWBhhjOhEsb7MsROgz897rHzDZw4UcmPbqSAuTeoVlXL5W9YcA9qOtyFrtduwse56KJD3RASS0ajRo9qQzxuDWyFwNFR/Qp9FvHwGVsGLQP0yaXveYpmP3y05K6jhG3xwz1ERMoAogcNXrdXONmaGgknKL2ckG6vygIEq/PPam2JRYwledJIlj0GEnzWY83NV289zZD+0KNsISbN2N8CbwXgF/WS/77PC5mxraYc8Wn4IV5KzqprtHDA84mwuDzJLlZaTX/QrIGvZ2Rv76vacUOhQZm/VVDN/R+lWO2nwy2Q8a7IKcuGYj7qULoJRlI3pHNlFZCBedSlV/dP8rlCNZxiHC6ahylYEAawMnD6BDg2DfFAVOePjpVuIiEFiRn5zBWKx8zwOaneATzFA8Xgg/uIdfs89AtMHG4z1x3fv/lwUx9tlqohQAPsjACSKyBui9KRmjp62qZUjci7XPClI7owTOCD7clGkWsmf8NQR+X2tAZV6nKVQh7lpMwNUAvHpd5bxEng+TH0Zsu68JJbxzW6j4f/CsFTv7u3iHaqXWATvkp7vcOfkcc0tpoRJq3HHGvd+PONKqUY8yvhY9f60LoM3FCBHAmAqhmTXfoaFTmPqEIXhc6YzrlqsiJk2urcoW45k5uNWkSsb/7vap1A==
import heapq, re

data = open('data-16.txt').read().strip().splitlines()

flows = {}
edges = {}

for line in data:
    valves = re.findall('[A-Z][A-Z]', line)
    valve = valves.pop(0)
    flow = re.findall('\d+', line)[0]
    flows[valve] = int(flow)
    edges[valve] = valves

def make_yo_move(state):
    time, pos, opened = state
    s = []
    for next in edges[pos]:
        s.append(tuple([time-1, next, opened]))
    if pos not in opened and flows[pos] != 0:
        s.append(tuple([time-1, pos, opened|frozenset([pos])]))
    return s

def team_elephant(state):
    time, team, opened = state
    human, elephant = list(team)[0]
    s = []
    for next_human in edges[human]:
        for next_elephant in edges[elephant]:
            s.append(tuple([time-1, frozenset([(next_human,next_elephant)]), opened]))
    if human not in opened and flows[human] != 0:
        for next_elephant in edges[elephant]:
            s.append(tuple([time-1, frozenset([(human,next_elephant)]), opened|frozenset([human])]))
    if elephant not in opened and flows[elephant] != 0:
        for next_human in edges[human]:
            s.append(tuple([time-1, frozenset([(next_human,elephant)]), opened|frozenset([elephant])]))
        if human not in opened and flows[human] != 0:
            s.append(tuple([time-1, frozenset([(human,elephant)]), opened|frozenset([elephant])|frozenset([human])]))
    return s

def highest_pressure_search(successors):
    frontier = []
    pressure_released = {}
    if successors.__name__ == 'make_yo_move':
        start = tuple([29, 'AA', frozenset()])
    else:
        start = tuple([25, frozenset([('AA','AA')]), frozenset()])
    heapq.heappush(frontier, (0,start))
    pressure_released[start] = 0
    cull = 10000
    culls = list(range(15))
    while frontier:
        current = heapq.heappop(frontier)[1]
        if current[0] == 0:
            return pressure_released[current]
        if current[0] == culls[-1]:
            frontier = heapq.nsmallest(cull,frontier)
            del culls[-1]
        for next in successors(current):
            time, pos, opened = next
            pressure = sum([flows[x] for x in opened])
            new_pressure = pressure_released[current] + pressure
            if next not in pressure_released or new_pressure > pressure_released[next]:
                pressure_released[next] = new_pressure
                priority = -(time*1000)-new_pressure
                heapq.heappush(frontier, (priority, next))

    return 'Fail'

print(highest_pressure_search(make_yo_move), highest_pressure_search(team_elephant))
