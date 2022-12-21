def step1(example = false)
  input = example == 'example' ? @input_example : @input
  @monkeys = {}
  make_input(input)
  @needed = ['root']
  calculate_root
  root = @monkeys.select { |k| k == 'root' }
  p root['root'][:number]
  # p @monkeys
end

def make_input(input)
  input.each do |line|
    name, number = line.strip.split(': ')
    op = nil
    a = nil
    b = nil
    if number.to_i != 0
      number = number.to_i
    else
      a, op, b = number.split(' ')
      number = nil
    end
    @monkeys[name] = { number:, a:, b:, op: }
  end
  # p @monkeys
end

def calculate_root
  while @needed.length.positive?
    name = @needed.shift
    next if @monkeys[name][:number]

    a = @monkeys[name][:a]
    b = @monkeys[name][:b]
    if @monkeys[a][:number] && @monkeys[b][:number]
      @monkeys[name][:number] = @monkeys[a][:number].method(@monkeys[name][:op]).call(@monkeys[b][:number])
      @needed.delete(a)
      @needed.delete(b)
    else
      @needed << a
      @needed << b
      @needed << name
      @needed.uniq!
    end
  end
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
  @monkeys = {}
  make_input(input)
  root = @monkeys.select { |k| k == 'root' }
  root['root'][:op] = '=='

  @needed = [root['root'][:a]]

  @needed = if human_in_a? # calculate b
              [root['root'][:b]]
            else
              [root['root'][:a]]
            end
  calculate_root
  try_humns(example ? 1 : 3_916_936_880_400, example ? 1 : 100)
end

def human_in_a?
  while @needed.length.positive?
    name = @needed.shift
    next if @monkeys[name][:number]

    a = @monkeys[name][:a]
    b = @monkeys[name][:b]
    return true if [a, b].include?('humn')

    if @monkeys[a][:number] && @monkeys[b][:number]
      @monkeys[name][:number] = @monkeys[a][:number].method(@monkeys[name][:op]).call(@monkeys[b][:number])
      @needed.delete(a)
      @needed.delete(b)
    else
      @needed << a
      @needed << b
      @needed << name
      @needed.uniq!
    end
  end
  false
end

def try_humns(humn, step)
  # TODO: implement better lopping with 10_000_000 step at first then slowly reduce step and adjust initial humn
  # (did it manually )
  loop do
    p humn
    new_monkeys = Marshal.load(Marshal.dump(@monkeys))
    human = new_monkeys.select { |k| k == 'humn' }
    human['humn'][:number] = humn

    needed = ['root']
    get_humn(new_monkeys, needed)

    root = new_monkeys.select { |k| k == 'root' }
    p [new_monkeys[root['root'][:a]][:number], new_monkeys[root['root'][:b]][:number]]
    break if root['root'][:number] == true
    break if new_monkeys[root['root'][:a]][:number] < new_monkeys[root['root'][:b]][:number]

    humn += step
  end
  p humn
end

def get_humn(array, needed)
  while needed.length.positive?
    name = needed.shift
    next if array[name][:number]

    a = array[name][:a]
    b = array[name][:b]
    if array[a][:number] && array[b][:number]
      array[name][:number] = array[a][:number].method(array[name][:op]).call(array[b][:number])
      needed.delete(a)
      needed.delete(b)
    else
      needed << a
      needed << b
      needed << name
      needed.uniq!
    end
  end
end
