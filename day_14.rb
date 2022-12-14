def step1(example = false)
  input = example == 'example' ? @input_example : @input
  @grid = []
  @settled = 0
  make_grid(input)
  sand_flows
  p @settled
end

def make_grid(input, floor = false)
  @min_x = 500
  @max_x = 500
  @max_y = 0

  # find size of grid
  input.each do |line|
    line.split(' -> ').each do |coords|
      x, y = coords.split(',')
      @min_x = x.to_i if x.to_i < @min_x
      @max_x = x.to_i if x.to_i > @max_x
      @max_y = y.to_i if y.to_i > @max_y
    end
  end
  # p [@min_x, @max_x, @max_y]
  (@max_y + 1).times { @grid << Array.new(@max_x - @min_x + 1, '.') } # make grid
  @grid[0][500 - @min_x] = '+' # starting sand
  # show_grid

  # draw lines
  input.each do |line|
    prev_x = nil
    prev_y = nil
    line.strip.split(' -> ').each do |coords|
      x, y = coords.split(',')
      x = x.to_i
      y = y.to_i
      @grid[y][x - @min_x] = '#'
      if prev_x && prev_x != x # horizontal line
        x < prev_x ?
          (x..prev_x).each { |i| @grid[y][i - @min_x] = '#' } :
          (prev_x..x).each { |i| @grid[y][i - @min_x] = '#' }
      end
      if prev_y && prev_y != y # vertical line
        prev_y < y ?
          (prev_y..y).each { |i| @grid[i][x - @min_x] = '#' } :
          (y..prev_y).each { |i| @grid[i][x - @min_x] = '#' }
      end
      prev_x = x
      prev_y = y
    end
  end
  return unless floor

  # widen
  wider_by = 150
  # wider_by = 10 # for example
  @grid.map do |row|
    wider_by.times do
      row.prepend('.')
      row << '.'
    end
  end
  @min_x -= wider_by
  @max_x += wider_by

  @grid << Array.new(@max_x - @min_x + 1, '.')
  @grid << Array.new(@max_x - @min_x + 1, '#')
end

def sand_flows
  overflow = false
  until overflow
    current_sand = [500 - @min_x, 0]
    moving = true
    while moving
      unless @grid[current_sand[1] + 1]
        overflow = true
        break
      end

      if ['#', 'o'].include? @grid[current_sand[1] + 1][current_sand[0]]
        # move diag left
        if @grid[current_sand[1] + 1][current_sand[0] - 1] == '.'
          current_sand[0] -= 1
          current_sand[1] += 1
          next
        # move diag right
        elsif @grid[current_sand[1] + 1][current_sand[0] + 1].nil?
          overflow = true
          break

        elsif @grid[current_sand[1] + 1][current_sand[0] + 1] == '.'
          current_sand[0] += 1
          current_sand[1] += 1
          next
        end
        # stay here
        @grid[current_sand[1]][current_sand[0]] = 'o'
        @settled += 1
        moving = false
      else
        current_sand[1] += 1
      end
    end
  end
  # show_grid
end

def show_grid
  @grid.each { |row| p row }
end
def display_grid
  @grid.each { |row| p row.join(",") }
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
  @grid = []
  @fallen = 0
  make_grid(input, 'floor')
  sand_flows2
  display_grid
  p @fallen
end

def sand_flows2
  top = false
  until top
    current_sand = [500 - @min_x, 0]
    moving = true
    while moving
      if ['#', 'o'].include? @grid[current_sand[1] + 1][current_sand[0]]
        # move diag left
        if @grid[current_sand[1] + 1][current_sand[0] - 1] == '.'
          current_sand[0] -= 1
          current_sand[1] += 1
          next
        # move diag right
        elsif @grid[current_sand[1] + 1][current_sand[0] + 1] == '.'
          current_sand[0] += 1
          current_sand[1] += 1
          next
        end
        # stay here
        @grid[current_sand[1]][current_sand[0]] = 'o'
        @fallen += 1
        moving = false
        if current_sand == [500 - @min_x, 0]
          top = true
          break
        end
      else
        current_sand[1] += 1
      end
    end
  end
  # show_grid
end
