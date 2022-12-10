def step1(example = false)
  input = example == 'example' ? @input_example : @input
  @x = 1
  @cycle = 0
  @sum = 0
  input.each do |line|
    cycle(line.strip)
  end
  p @sum
end

def cycle(line)
  cycle_up
  return if line == 'noop'

  cycle_up
  @x += line.split(' ')[1].to_i
end

def cycle_up
  @cycle += 1
  add_up if [20, 60, 100, 140, 180, 220].include? @cycle
end

def add_up
  # p [@cycle, @x]
  @sum += (@x * @cycle)
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
  @x = 1 # meaning sprite is 0,1,2 indices
  @y = 0
  @cycle = 0
  @screen = []
  6.times { @screen << [] }

  input.each do |line|
    tv_cycle(line.strip)
  end

  @screen.each{ |row| p row }
end

def tv_cycle(line)
  draw
  return if line == 'noop'

  draw
  @x += line.split(' ')[1].to_i
end

def draw
  char = [@x - 1, @x, @x + 1].include?(@cycle - @y * 40) ? '#' : '.'
  @screen[@y] << char
  @cycle += 1
  @y += 1 if [40, 80, 120, 160, 200, 240].include?(@cycle)
end
