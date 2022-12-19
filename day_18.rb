def step1(example = false)
  input = example == 'example' ? @input_example : @input
  @coords = make_coords(input)
  calculate
end

def make_coords(input)
  input.map do |line|
    string_coords = line.strip.split(',')
    x = string_coords[0].to_i
    y = string_coords[1].to_i
    z = string_coords[2].to_i
    { x:, y:, z: }
  end
end

def calculate
  # two cubes are touching when two of their x/y/z are the
  # same and the one that isn't the same is +|- 1 off from the other coordinate

  # these are touching:
  # 1,1,1
  # 2,1,1

  # these are not touching:
  # 1,1,1
  # 3,1,1

  visible_sides = 0
  seen = []
  @coords.each do |coordinates|
    x = coordinates[:x]
    y = coordinates[:y]
    z = coordinates[:z]
    touching_cubes = seen.select do |seen_cube|
      # same_xy
      ((seen_cube[:x] == x && seen_cube[:y] == y) && ((seen_cube[:z] - z).abs == 1)) ||
        # same_yz
        ((seen_cube[:z] == z && seen_cube[:y] == y) && ((seen_cube[:x] - x).abs == 1)) ||
        # same_xz
        ((seen_cube[:x] == x && seen_cube[:z] == z) && ((seen_cube[:y] - y).abs == 1))
    end
    visible_sides += 6 - touching_cubes.size * 2
    seen << coordinates
  end

  p visible_sides
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
  @max_x = 0
  @max_y = 0
  @max_z = 0
  @coords = make_coords2(input)
  @scan = make_scan
  calculate2
end

def make_coords2(input)
  input.map do |line|
    string_coords = line.strip.split(',')
    x = string_coords[0].to_i
    y = string_coords[1].to_i
    z = string_coords[2].to_i
    @max_x = x if x > @max_x
    @max_y = y if y > @max_y
    @max_z = z if z > @max_z
    { x:, y:, z: }
  end
end

def make_scan
  row = Array.new(@max_x, '.')
  plane = Array.new(@max_y, row)
  Array.new(@max_z, plane)
end

def display_scan
  @scan.each_with_index do |plane, i|
    p "z: #{i + 1}"
    plane.each do |row|
      p row
    end
  end
end

def calculate2
  @coords.each do |coordinates|
    x = coordinates[:x]
    y = coordinates[:y]
    z = coordinates[:z]
    p [x, y, z]
    @scan[z - 1][y - 1][x - 1] = '#'
  end
  display_scan
end
