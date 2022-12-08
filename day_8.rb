def step1(example = false)
  input = example == 'example' ? @input_example : @input
  length = input[0].strip.length
  @result_grid = []
  @cols = []

  count = 0
  length.times { @result_grid << Array.new(length, 0) }
  length.times { @cols << Array.new(length, nil) }
  make_cols(input)

  rows(input)
  cols
  @result_grid.each do |row|
    # p row
    count += row.grep(1).size
  end
  p count
end

def make_cols(input)
  input.each_with_index do |line, index|
    row = line.strip.split('')
    row.each_with_index do |tree, i|
      @cols[i][index] = tree
    end
  end
  # p "Cols"
  # p @cols.each{ |row| p row }
end

def visible?(tree, index, row)
  row.each_with_index do |other_tree, i|
    return true if i == index

    break if other_tree >= tree
  end
  row.reverse.each_with_index do |other_tree, i|
    return true if i == (row.length - index - 1)

    break if other_tree >= tree
  end

  false
end

def rows(input)
  input.each_with_index do |line, index|
    length = line.strip.length
    @result_grid[index] = Array.new(length, 1) if index.zero? || index == length - 1

    row = line.strip.split('')
    row.each_with_index do |tree, i|
      @result_grid[index][i] = 1 if i.zero? || i == length - 1

      @result_grid[index][i] = 1 if visible?(tree, i, row)
    end
  end
end

def cols
  @cols.each_with_index do |col, y|
    col.each_with_index do |tree, x|
      next if x.zero? || x == col.length - 1

      @result_grid[x][y] = 1 if visible?(tree, x, col)
    end
  end
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
  length = input[0].strip.length

  @cols = []
  length.times { @cols << Array.new(length, nil) }
  make_cols(input)

  max_score = 0

  input.each_with_index do |row_unplit, y|
    row = row_unplit.strip.split('')
    row.each_with_index do |tree, x|
      # skip outer rows
      next if x.zero? || y.zero? || y == row.length - 1 || x == row.length - 1

      # p ["coords", x,y]
      e = view_with_flow(tree, x, row)
      w = view_against_flow(tree, x, row)
      n = view_against_flow(tree, y, @cols[x])
      s = view_with_flow(tree, y, @cols[x])

      score = e * w * n * s
      max_score = score if score > max_score
    end
  end

  p max_score
end

def view_with_flow(tree, x, row)
  count = 0
  row.each_with_index do |other_tree, i|
    # ignore west
    next if i <= x

    # p ["tree comp",x, other_tree, tree]
    count += 1 if other_tree < tree
    if other_tree >= tree
      count += 1
      break
    end
  end
  # p ["east", count]
  count
end

def view_against_flow(tree, x, row)
  count = 0
  i = x - 1
  while i >= 0
    count += 1 if row[i] < tree

    if row[i] >= tree
      count += 1
      break
    end
    i -= 1
  end
  # p ["west", count]
  count
end
