def step1(example = false)
  # R 4
  # U 4
  # L 3
  # D 1
  # R 4
  # D 1
  # L 5
  # R 2

  input = example == 'example' ? @input_example : @input
  @height = example ? 5 : 1000
  @width = example ? 6 : 1000
  @grid = make_grid
  # p @grid
  start_y = example ? @height - 1 : @height / 2
  start_x = example ? 0 : @width / 2

  # coords y,x
  @h = [start_y, start_x]
  @t = [start_y, start_x]
  input.each_with_index do |line, _index|
    direction, count = line.strip.split(' ')
    count.to_i.times do
      go(direction)
      t_follows
      t_leaves_a_marker
    end
  end
  calculate
end

def make_grid
  grid = []
  @height.times do
    grid << Array.new(@width, '.')
  end
  grid
end

def go(direction)
  @h[0] -= 1 if direction == 'U'
  @h[1] += 1 if direction == 'R'
  @h[0] += 1 if direction == 'D'
  @h[1] -= 1 if direction == 'L'

  p 'too w' unless @h[1] >= 0 && @h[1] < @width
  p 'too h' unless @h[0] >= 0 && @h[0] < @height
end

def t_follows
  x_distance = (@h[1] - @t[1]).abs
  y_distance = (@h[0] - @t[0]).abs
  return if x_distance <= 1 && y_distance <= 1

  # catch_up vertical
  @t[0] = (@h[0] + @t[0]) / 2 if y_distance == 2 && x_distance.zero?
  # catch_up horizontal
  @t[1] = (@h[1] + @t[1]) / 2 if y_distance.zero? && x_distance == 2
  # catch_up diagonal
  if x_distance == 2 && y_distance == 1
    @t[0] = @h[0]
    @t[1] = (@h[1] + @t[1]) / 2
  end
  if y_distance == 2 && x_distance == 1
    @t[0] = (@h[0] + @t[0]) / 2
    @t[1] = @h[1]
  end
  p [@h, @t]
end

def t_leaves_a_marker
  y = @t[0]
  x = @t[1]
  @grid[y][x] = '#' if @grid[y][x] == '.'
end

def calculate
  # p @grid
  count = 0
  @grid.each do |row|
    # p row
    count += row.grep('#').size
  end
  p count
end

# ***

def step2(example = false)
  input = example == 'example' ? @input_example : @input
  @height = example ? 30 : 1000
  @width = example ? 30 : 1000
  @grid = make_grid
  # p @grid
  start_y = @height / 2
  start_x = @width / 2

  @h = [start_y, start_x]
  @positions = {}
  9.times do |i|
    @positions[i + 1] = [start_y, start_x]
  end

  input.each_with_index do |line, _index|
    direction, count = line.strip.split(' ')
    count.to_i.times do
      go(direction)
      @positions.each do |k, follower|
        front = k == 1 ? @h : @positions[k - 1]
        next if front == follower

        @positions[k] = next_follows(front, follower)
      end
      nine_leaves_a_marker
    end
  end
  calculate
end

def next_follows(front, follower)
  # p [front, follower]
  x_distance = (front[1] - follower[1]).abs
  y_distance = (front[0] - follower[0]).abs
  return follower if x_distance <= 1 && y_distance <= 1

  # catch_up vertical
  follower[0] = (front[0] + follower[0]) / 2 if y_distance == 2 && x_distance.zero?
  # catch_up horizontal
  follower[1] = (front[1] + follower[1]) / 2 if y_distance.zero? && x_distance == 2
  # catch_up diagonal
  if x_distance == 2 && y_distance == 1
    follower[0] = front[0]
    follower[1] = (front[1] + follower[1]) / 2
  end
  if y_distance == 2 && x_distance == 1
    follower[0] = (front[0] + follower[0]) / 2
    follower[1] = front[1]
  end
  if y_distance == 2 && x_distance == 2
    follower[0] = (front[0] + follower[0]) / 2
    follower[1] = (front[1] + follower[1]) / 2
  end
  follower
end

def nine_leaves_a_marker
  # p @positions[9]
  y = @positions[9][0]
  x = @positions[9][1]
  @grid[y][x] = '#' if @grid[y][x] == '.'
end
