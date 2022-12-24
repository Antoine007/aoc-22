with open("data-23.txt") as fo:
    lines = fo.read().strip('\n').split('\n')

positions = (
    ((-1, 0), (-1,-1), (-1, 1)), # North
    (( 1, 0), ( 1,-1), ( 1, 1)), # South
    (( 0,-1), (-1,-1), ( 1,-1)), # West
    (( 0, 1), (-1, 1), ( 1, 1)), # East
)


def run(number=2**63):
    # Elves positions, and their proposed next position
    elves = {(y,x): False
            for x in range(len(lines[0]))
            for y in range(len(lines))
            if lines[y][x] == '#'}

    stage = 0   # Position elves start looking in
    i = 0
    while i < number:
        for elf in elves:
            # Check if elf can stay put and
            # determine direction elf would move in
            can_stay = True
            proposed_dir = None
            # Loop over 4 wind directions
            for dir in range(stage, stage+4):
                empty_side = True
                # Loop over three positions in this wind direction
                for pos in positions[dir%4]:
                    # If one position is occupied, elf cannot stay,
                    # and cannot move in that direction. So check next
                    if (elf[0]+pos[0], elf[1]+pos[1]) in elves:
                        can_stay = False
                        empty_side = False
                # If the side was empty, and no direction was
                # empty earlier on, set this direction
                if empty_side and proposed_dir is None:
                    proposed_dir = dir % 4

            # Store proposed new position (if any)
            if can_stay or proposed_dir is None:
                elves[elf] = False
            else:
                elves[elf] = (elf[0] + positions[proposed_dir][0][0],
                            elf[1] + positions[proposed_dir][0][1])

        # Check if elves can move into proposed position
        # Store in a new dict and then reassign
        proposed_list = list(elves.values())
        new_elves = {}
        for elf, proposed in elves.items():
            if proposed:
                if proposed_list.count(proposed) == 1:
                    new_elves[proposed] = False  # Create new position
                    continue
            new_elves[elf] = False       # Keep same position
        if elves.keys() == new_elves.keys():
            # If the new keys are the same as the old,
            # no change has occurred. Return round number.
            return f"{i + 1} rounds"
        elves = new_elves

        # Prepare next loop (change first direction to search in)
        stage = (stage + 1) % 4
        i += 1


    # Determine complete area
    ylist = [elf[0] for elf in elves]
    xlist = [elf[1] for elf in elves]
    ymin = min(ylist)
    ymax = max(ylist)
    xmin = min(xlist)
    xmax = max(xlist)

    return (ymax-ymin+1) * (xmax-xmin+1) - len(elves)

result1 = run(10)
print("The result is for part 1 is:", result1)

result2 = run()
print("The result is for part 2 is:", result2)
