require 'set'

def step1(example = false)
  input = example == 'example' ? @input_example : @input
  @beacons = Set.new
  @sensors = {}
  @focus_row = example == 'example' ? 10 : 2_000_000
  make_beacons(input)
  @max_x = [@sensors.keys.map(&:first).max, @beacons.map(&:first).max].max
  @max_dist = @sensors.values.max
  make_row(@focus_row)
end

def make_beacons(input)
  input.each do |line|
    sensor, beacon = line.strip.split(':')

    x, y = sensor.scan(/\d+/).map(&:to_i)
    bx, by = beacon.scan(/-?\d+/).map(&:to_i)

    dist = (x - bx).abs + (y - by).abs

    @sensors[[x, y]] = dist
    @beacons << [bx, by]
  end
end

def make_row(y)
  count = 0
  (-@max_dist..@max_x + @max_dist).each do |x|
    next if @beacons.include?([x, y]) || @sensors[[x, y]]

    @sensors.each do |(sx, sy), dist|
      if (x - sx).abs + (y - sy).abs <= dist
        count += 1
        break
      end
    end
  end
  p count
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
  @sensors = {}
  @max_coord = example == 'example' ? 20 : 4_000_000
  make_sensors(input)
  @rows = Hash.new { |h, k| h[k] = [] }
  make_rows
  # p @rows
  x, y = find_beacon
  calculate(x, y)
end

def make_sensors(input)
  input.each do |line|
    sensor, beacon = line.strip.split(':')

    x, y = sensor.scan(/\d+/).map(&:to_i)
    bx, by = beacon.scan(/-?\d+/).map(&:to_i)

    dist = (x - bx).abs + (y - by).abs

    @sensors[[x, y]] = dist
  end
end

def make_rows
  @sensors.each do |(x, y), dist|
    print '.'

    x1 = x - dist
    x2 = x + dist

    (dist + 1).times do |i|
      range = [x1 + i, x2 - i]
      @rows[y + i] << range.clone
      @rows[y - i] << range.clone
    end
  end
end

def find_beacon
  (@max_coord + 1).times.each do |y|
    print '.' if (y % 100_000).zero?

    ranges = @rows[y].sort
    range = ranges.shift

    ranges.each do |(from, to)|
      if from <= range[1]
        range[1] = [range[1], to].max
      else
        x = from - 1

        return [x, y]
      end
    end
  end
end

def calculate(x, y)
  p x * 4_000_000 + y
end
