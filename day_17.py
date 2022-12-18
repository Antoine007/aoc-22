from itertools import cycle

with open("data-17.txt") as fo:
    lines = fo.read().strip('\n').split('\n')


class Rock():

    @classmethod
    def initiate(cls):
        cls.tallness = 0
        cls.situation = {}
        cls.types = {
            'hor': [[True, True, True, True]],
            'plus': [[False,True,False],[True,True,True],[False,True,False]],
            'revl': [[True,True,True],[False,False,True],[False,False,True]],
            'ver': [[True],[True],[True],[True]],
            'block': [[True,True],[True,True]]
        }
        cls.next_type = cycle(cls.types.keys())
        cls.jet = cycle([-1 if c == '<' else +1 for c in lines[0]])
        cls.jet_stage = 0
        cls.states = {}
        cls.height_check = 40


    def __init__(self):
        self.type = next(Rock.next_type)
        self.width = len(Rock.types[self.type][0])
        self.height = len(Rock.types[self.type])
        self.left = 2
        self.right = self.left + self.width - 1
        self.bottom = Rock.tallness + 4
        self.top = self.bottom + self.height - 1
        self.stopped = False


    def move_hor(self):
        move = Rock.next_jet()
        can_move = (self.right < 6) if (move == 1) else (self.left > 0)
        for x in range(self.width):
            for y in range(self.height):
                if Rock.types[self.type][y][x] and \
                    Rock.situation.get((self.left + x + move,
                                        self.bottom + y)) == '#':
                    can_move = False
        if can_move:
            self.left += move
            self.right += move


    def move_down(self):
        if self.bottom == 1:
            self.stopped = True
        else:
            for x in range(self.width):
                for y in range(self.height):
                    if Rock.types[self.type][y][x] and \
                        Rock.situation.get((self.left + x,
                                            self.bottom + y - 1)) == '#':
                        self.stopped = True
        if self.stopped:
            Rock.tallness = max(Rock.tallness, self.top)
            self._update()
        else:
            self.top -= 1
            self.bottom -= 1


    def _update(self):
        """Update situation of the field and
        recalculate the composition of the top rows (used to record state)"""
        for y in range(self.height):
            for x in range(self.width):
                if Rock.types[self.type][y][x]:
                    Rock.situation[(self.left + x, self.bottom + y)] = '#'
        Rock.top_rows = ''.join(
                ''.join(Rock.situation.get((x,y), ".") for x in range(7))
                    for y in range(Rock.tallness, Rock.tallness - Rock.height_check, -1))


    @classmethod
    def next_jet(cls):
        cls.jet_stage = (cls.jet_stage) % len(lines[0])
        return next(cls.jet)


    @classmethod
    def fast_forward(cls, incr_height, incr_i):
        for x in range(7):
            for y in range(cls.height_check):
                old = Rock.situation.get((x, Rock.tallness - y), None)
                if old:
                    Rock.situation[(x, Rock.tallness  + incr_height - y)] = old
        Rock.tallness += incr_height
        for _ in range(incr_i % len(cls.types)):
            next(cls.next_type)


    @classmethod
    def show(cls):
        for y in range(cls.tallness + 4, 0, -1):
            for x in range(7):
                print(cls.situation.get((x,y),'.'), end='')
            print('')
        print('')


    @classmethod
    def show_highest(cls, base=10):
        for y in range(base):
            print('\n', y, end=' >')
            for x in range(7):
                print(Rock.situation.get((x,Rock.tallness - y),'.'), end='')


def run(times):
    Rock.initiate()
    i = 0
    while i < times:
        rock = Rock()
        # Move as long as you can
        while not rock.stopped:
            rock.move_hor()
            rock.move_down()

        # Check previous state for repeating patterns
        state = Rock.top_rows
        prev_i, prev_height = Rock.states.get(state, (None, None))
        # If there is a previous state, fast-forward
        if prev_i:
            step = i - prev_i
            repeat = ((times - i) // step)
            incr_height = (Rock.tallness - prev_height) * repeat
            incr_i = step * repeat
            i += incr_i
            Rock.fast_forward(incr_height, incr_i)
        else:
            # No previous state, so record it
            Rock.states[state] = (i, Rock.tallness)

        i += 1

    return Rock.tallness


result1 = run(2022)
result2 = run(1_000_000_000_000)

print("The result is for part 1 is:", result1)
print("The result is for part 2 is:", result2)
