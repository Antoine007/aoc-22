def step1(example = false)
  input = example == 'example' ? @input_example : @input
  @monkeys = {}
  @current_monkey = -1
  # @round = 1

  initial_build(input)
  let_them_play(20)

  monkey_print
  calculate
end

def initial_build(input)
  input.each do |line|
    next if line.strip == ''

    if line.strip.split(' ')[0] == 'Monkey'
      @current_monkey += 1
      @monkeys[@current_monkey.to_s] = { inspected: 0 }
    end

    if line.strip.split(' ')[0] == 'Starting'
      list = []
      line.strip.split(':')[1].split(',').each { |i| list << i.strip.to_i }
      @monkeys[@current_monkey.to_s][:items] = list
    end
    if line.strip.split(' ')[0] == 'Operation:'
      @monkeys[@current_monkey.to_s][:op] = line.strip.split('old').last.split(' ')[0]
      old = line.strip.split('old').last.split(' ')[1]
      @monkeys[@current_monkey.to_s][:by] = old || 'old'
    end
    if line.strip.split(' ')[0] == 'Test:'
      @monkeys[@current_monkey.to_s][:divisible_by] = line.strip.split(' ').last.to_i
    end
    if line.strip.split(':')[0] == 'If true'
      @monkeys[@current_monkey.to_s][:div_throw_to] = line.strip.split(' ').last.to_i
    end
    if line.strip.split(':')[0] == 'If false'
      @monkeys[@current_monkey.to_s][:not_div_throw_to] = line.strip.split(' ').last.to_i
    end
  end
end

def let_them_play(iterations, reduce_stress = false)
  iterations.times do |index|
    @monkeys.each_value do |monkey|
      one_monkey_round(monkey, reduce_stress) while monkey[:items].length.positive?
    end
    p "END of round #{index}"
  end
end

def one_monkey_round(monkey, modulo = false)
  monkey[:items].sort
  monkey[:inspected] += 1
  item = monkey[:items][0]
  monkey[:items].delete_at(0)

  by = monkey[:by] == 'old' ? item : monkey[:by].to_i
  item = item.method(monkey[:op]).call(by)

  item = modulo ? item % modulo : (item / 3).floor

  if (item.to_i % monkey[:divisible_by]).zero?
    @monkeys[monkey[:div_throw_to].to_s][:items] << item
  else
    @monkeys[monkey[:not_div_throw_to].to_s][:items] << item
  end
end

def monkey_print
  @monkeys.each do |key, val|
    p "Monkey: #{key}: #{val[:items]}, inspected: #{val[:inspected]}"
  end
end

def calculate
  top = []
  @monkeys.sort_by { |_k, v| v[:inspected] }.last(2).each { |v| top << v[1][:inspected] }
  p top[0] * top[1]
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
  @monkeys = {}
  @current_monkey = -1

  initial_build(input)

  dividers = []
  @monkeys.each_value { |monkey| dividers << monkey[:divisible_by] }
  @modulo = dividers.reduce(:lcm)

  let_them_play(10_000, @modulo)

  monkey_print
  calculate
end
