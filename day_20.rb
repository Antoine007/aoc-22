def step1(example = false)
  input = example == 'example' ? @input_example : @input
  @initial = input.map { |line| line.strip.to_i }
  @file = @initial.clone
  @sum = 0
  mix
  calculate
  p @sum # 3 and 7153
end

def mix(its = 1)
  max_index = @file.length - 1
  its.times do
    @initial.each do |x|
      origin = @file.find_index(x)
      @file.delete_at(origin)
      destination = (x + origin) % max_index
      destination = max_index if destination.zero?
      @file.insert(destination, x)
      # p @file
    end
    p @file.count(nil)
  end
end

def calculate
  zero_index = @file.find_index(0)
  [1000, 2000, 3000].each do |i|
    index = zero_index + i % @input.length
    position = index % @file.length
    @sum += @file[position]
  end
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input

  @initial = input.map { |line| line.strip.to_i * 811_589_153 }
  @file = @initial.clone
  @sum = 0
  mix(10)
  calculate
  p @sum # 1623178306 and
end
