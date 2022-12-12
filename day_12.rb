def step1(example = false)
  input = example == 'example' ? @input_example : @input
  run(input)
end
def step2(example = false)
  input = example == 'example' ? @input_example : @input
  run2(input)
end

def run(input)
  map = []
  input.each do |line|
    map <<
      line.chars.map do |x|
        if %w[S E].include?(x)
          if x == 'S'
            0
          else
            27
          end
        else
          x.ord - 96
        end
      end
  end
  start_x = 0
  start_y = 0
  end_x = 0
  end_y = 0
  map.each_with_index do |x, idx|
    x.each_with_index do |y, idy|
      if y == 27
        end_x = idx
        end_y = idy
      end
      if y.zero?
        start_x = idx
        start_y = idy
      end
    end
  end
  visited = {}
  step(start_x, start_y, map, 0, visited)
  p visited["#{end_x}:#{end_y}"]
end

def step(x, y, map, steps, visited)
  return visited if !visited["#{x}:#{y}"].nil? && steps >= visited["#{x}:#{y}"]

  visited["#{x}:#{y}"] = steps
  current = map[x][y]
  return visited if current == 27

  up = (y - 1 >= 0 ? map[x][y - 1] : 30)
  down = (y + 1 <= map.first.size - 1 ? map[x][y + 1] : 30)
  left = (x - 1 >= 0 ? map[x - 1][y] : 30)
  right = (x + 1 <= map.size - 1 ? map[x + 1][y] : 30)

  visited = step(x, y - 1, map, steps + 1, visited) if up - current < 2 || (current == 25 && up == 27)
  visited = step(x, y + 1, map, steps + 1, visited) if down - current < 2 || (current == 25 && down == 27)
  visited = step(x - 1, y, map, steps + 1, visited) if left - current < 2 || (current == 25 && left == 27)
  visited = step(x + 1, y, map, steps + 1, visited) if right - current < 2 || (current == 25 && right == 27)
  visited
end

def run2(input)
  map = []
  input.each do |line|
    map <<
      line.chars.map do |x|
        if %w[S E].include?(x)
          if x == 'S'
            0
          else
            27
          end
        else
          x.ord - 96
        end
      end
  end
  end_x = 0
  end_y = 0
  points = []
  map.each_with_index do |x, idx|
    x.each_with_index do |y, idy|
      if y == 27
        end_x = idx
        end_y = idy
      end
      points << [idx, idy] if y == 1
    end
  end
  paths = []
  points.each_with_index do |point, index|
    p "#{index}/#{points.size}"
    visited = {}
    step(point[0], point[1], map, 0, visited)
    paths << visited["#{end_x}:#{end_y}"]
  end
  p paths.compact.min
end
