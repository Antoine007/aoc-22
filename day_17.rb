def step1(example = false)
  input = example == 'example' ? @input_example : @input
  @proper_input = input
  @rocks = [
    [['@', '@', '@', '@']],
    [
      ['.', '@', '.'],
      ['@', '@', '@'],
      ['.', '@', '.']
    ],
    [
      ['.', '.', '@'],
      ['.', '.', '@'],
      ['@', '@', '@']
    ],
    [
      '@',
      '@',
      '@',
      '@'
    ],
    [
      ['@', '@'],
      ['@', '@']
    ]
  ]
  @cave = [Array.new(7, '-')]
  @directions = make_input(@proper_input)
  fall(2022)
end

def make_input(input)
  input.first.strip.split('')
end

def fall(iterations)
  # 2022.times do
  iterations.times do |i|
    rock_index = i % 5
    print '.' if rock_index.zero?
    # display_cave
    rock = @rocks[rock_index].clone
    add_rock(rock)
    rock_falls(rock)
  end
  # display_cave
  p @cave.length - 1 + (@culled || 0)
end

def display_cave
  @cave.each { |row| p row }
end

def add_rock(rock)
  3.times { @cave.prepend Array.new(7, '.') }
  rock_array = []
  rock_inners = rock.clone

  add_one_row(rock_array, rock_inners) until rock_inners.length.zero?

  @cave.prepend(rock_array.shift) until rock_array.length.zero?
end

def add_one_row(rock_array, rock)
  one_row = [['.', '.'], rock.pop].flatten
  one_row << '.' until one_row.length == 7
  rock_array << one_row
end

def rock_falls(rock)
  @blocked = false
  until @blocked
    @directions = make_input(@proper_input) if @directions.count.zero?

    horizontal_move(@directions.shift)
    # display_cave if rock == @rocks[4]
    drop
  end
end

def horizontal_move(direction)
  dir = direction == '<' ? -1 : 1
  can_move = true
  @cave.each do |row|
    next unless row.include? '@'

    row.each_with_index do |x, i|
      index = i + dir
      if x == '@' && (row[index].nil? || row[index] == '#' || index == -1)
        can_move = false
        break
      end
    end
  end
  return unless can_move

  @cave.each_with_index do |_row, i|
    next unless @cave[i].include? '@'

    indices = []
    @cave[i].each_with_index { |x, iz| indices << iz if x == '@' }
    if direction == '<'
      z = indices.last
      @cave[i][z] = '.'
      indices.each { |ix| @cave[i][ix - 1] = '@' }
    else
      z = indices.first
      @cave[i][z] = '.'
      indices.each { |ix| @cave[i][ix + 1] = '@' }
    end
  end
end

def drop
  can_go_down = true
  @cave.each_with_index do |_row, i|
    next unless @cave[i].include? '@'

    @cave[i].each_with_index do |x, index|
      next unless x == '@'

      if ['#', '-'].include? @cave[i + 1][index]
        can_go_down = false
        break
      end
    end
  end
  if can_go_down
    # go from bottom
    reversed_cave = @cave.clone.reverse
    reversed_cave.each_with_index do |row, i|
      next unless row.include?('@')

      row.each_with_index do |x, index|
        next unless x == '@'

        reversed_cave[i - 1][index] = '@'
        reversed_cave[i][index] = reversed_cave[i + 1] ? reversed_cave[i + 1][index] : '.'
      end
    end
    @cave = @cave.drop(1) if @cave[0] == Array.new(7, '.')
  else
    @cave.each_with_index do |row, i|
      next unless row.include?('@')

      row.each_with_index do |x, index|
        next unless x == '@'

        @cave[i][index] = '#'
      end
    end
    cull if @cave.find { |row| row == Array.new(7, '#') } && @culled
    @blocked = true
  end
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
  @proper_input = input
  @rocks = [
    [['@', '@', '@', '@']],
    [
      ['.', '@', '.'],
      ['@', '@', '@'],
      ['.', '@', '.']
    ],
    [
      ['.', '.', '@'],
      ['.', '.', '@'],
      ['@', '@', '@']
    ],
    [
      '@',
      '@',
      '@',
      '@'
    ],
    [
      ['@', '@'],
      ['@', '@']
    ]
  ]
  @cave = [Array.new(7, '-')]
  @directions = make_input(@proper_input)
  @culled = 0
  fall(1_000_000_000_000)
end

def cull
  # TODO: instead: find a recurring pattern and calculate the height that way
  i = @cave.find_index(Array.new(7, '#'))
  @culled += @cave.length - i - 1
  @cave = @cave.select.with_index { |_r, index| index < i }
  @cave << Array.new(7, '-')
  p 'CULL'
  p @culled
end
