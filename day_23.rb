def step1(example = false)
  input = example == 'example' ? @input_example : @input
  @directions = ["N", "S", "W", "E"]
  @grid = []
  make_input(input)
  1.times do
    move
  end
  display_grid
end


def move
  to_move = elves_to_move.clone
  add_north if to_move.find { |pos| pos[1].zero? }
  add_south if to_move.find { |pos| pos[1] == @grid.length - 1 }
  add_west  if to_move.find { |pos| pos[0].zero? }
  add_east  if to_move.find { |pos| pos[0] == @grid[0].length - 1 }
  next_locations = []
  4.times do
    direction = @directions.shift
    @directions << direction
    next_locations << wants_to_move(direction, to_move)
  end
end

def elves_to_move
  elves_to_move = []
  @grid.each_with_index do |row, y|
    row.each_with_index do |pos, x|
      next unless has_neighbour?(x, y)

      elves_to_move << [x, y] if pos == '#'
    end
  end
  elves_to_move
end

def wants_to_move(direction, arr)
  
end

def make_input(input)
  input.each do |line|
    @grid << line.strip.split('')
  end
end

def display_grid
  @grid.each { |row| p row }
end

def add_west
  @grid.each { |row| row.prepend('.') }
end

def add_east
  @grid.each { |row| row.append('.') }
end

def add_south
  l = @grid[0].length
  @grid.append(Array.new(l, '.'))
end

def add_north
  l = @grid[0].length
  @grid.prepend(Array.new(l, '.'))
end

def has_neighbour?(x,y)
  values = []
  values << @grid[y - 1][x - 1] if @grid[y - 1]
  values << @grid[y - 1][x]     if @grid[y - 1]
  values << @grid[y - 1][x + 1] if @grid[y - 1]
  values << @grid[y + 1][x - 1] if @grid[y + 1]
  values << @grid[y + 1][x]     if @grid[y + 1]
  values << @grid[y + 1][x + 1] if @grid[y + 1]
  values << @grid[y][x + 1]
  values << @grid[y][x + 1]

  values.uniq.include?('#')
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
end
