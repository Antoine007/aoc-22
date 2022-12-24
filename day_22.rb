def step1(example = false)
  input = example == 'example' ? @input_example : @input
  @grid = []
  @directions = []
  @cardinal = 1 # {e: 1, s: 2, w: 3, n: 4}
  make_input(input)
  @y = 0
  @x = @grid[0].find_index('.')
  first_move
  move
  @grid.each { |a| p a }
  p @x
  p @y
  p result
end

def result
  1000 * (@y + 1) + 4 * (@x + 1) + (@cardinal - 1)
end

def make_input(input)
  input.each do |line|
    break if line == "\n"

    @grid << line.split('').reject { |l| l == "\n" }
  end
  max_w = 0
  @grid.each { |row| max_w = row.length if row.length > max_w }
       .each { |row| row << ' ' until row.length == max_w }
  @directions << input.last.strip.split(/(?<=\d)(?=[A-Za-z])/)
  @directions.flatten!
end

def move
  until @directions.empty?
    instructions = @directions.shift
    cardinal_maker(instructions[0])
    its = instructions[1..].to_i
    its.times do
      next_spot = calculate_next_spot
      p next_spot
      break if next_spot[:value] == '#'

      @grid[@y][@x] = "$"
      @x = next_spot[:x]
      @y = next_spot[:y]
    end
  end
end

def first_move
  its = @directions.shift.to_i
  its.times do
    next_spot = calculate_next_spot
    break if next_spot[:value] == '#'

    @grid[@y][@x] = "$"
    @x = next_spot[:x]
    @y = next_spot[:y]
  end
end

def calculate_next_spot
  if @grid[next_y] && @grid[next_y][next_x] && ['#', '.'].include?(@grid[next_y][next_x])
    return { value: @grid[next_y][next_x], x: next_x, y: next_y }
  end

  if @cardinal.even? # vertical
    i = @y
    loop do
      return { value: @grid[i][@x], x: @x, y: i } if ['#', '.'].include?(@grid[i][@x])

      i += 1 if @cardinal == 2 # south
      i -= 1 if @cardinal == 4 # north
      i = 0 if i >= @grid.length || (@grid[i][@x] == ' ' && @cardinal == 2)
      i = @grid.length - 1 if i.negative? || (@grid[i][@x] == ' ' && @cardinal == 4)
    end
  else
    j = @x
    loop do
      return { value: @grid[@y][j], x: j, y: @y } if ['#', '.'].include?(@grid[@y][j])
      if @cardinal == 1 # east
        j += 1
        j = 0 if j >= @grid[@y].length || @grid[@y][j] == ' '
      end
      if @cardinal == 4 # west
        j -= 1
        j = @grid[@y].length - 1 if j.negative? || @grid[@y][j] == ' '
      end
    end
  end
end

def next_y
  return @y + 1 if @cardinal == 2
  return @y - 1 if @cardinal == 4

  @y
end

def next_x
  return @x + 1 if @cardinal == 1
  return @x - 1 if @cardinal == 3

  @x
end

def cardinal_maker(turn)
  if turn == 'L' # {e: 1, s: 2, w: 3, n: 4}
    return 4 if @cardinal == 1

    @cardinal -= 1
  else
    return 1 if @cardinal == 4

    @cardinal += 1
  end
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
end
