require 'json'

def step1(example = false)
  input = example == 'example' ? @input_example : @input

  @right_order = []
  @messages = { '1': {} }
  setup(input)

  go
  p @right_order.sum
end

def setup(input)
  right = false
  index = 1
  input.each do |line|
    if line.strip == ''
      index += 1
      @messages[index.to_s.to_sym] = {}
    elsif right
      @messages[index.to_s.to_sym][:right] = JSON.parse(line.strip)
      right = false
    else
      @messages[index.to_s.to_sym][:left] = JSON.parse(line.strip)
      right = true
    end
  end
end

def go
  @messages.each do |index, values|
    @right_order << index.to_s.to_i if compare(values[:left], values[:right])
  end
end

def compare(packet1, packet2)
  left, *remainder1 = packet1
  right, *remainder2 = packet2

  pair = [left, right]
  case
  when pair.all?(&:nil?)
    nil
  when left.nil?
    true
  when right.nil?
    false

  when class_match(pair, [Numeric, Numeric])
    return true if left < right
    return false if left > right

    compare(remainder1, remainder2)

  when class_match(pair, [Array, Array])
    is_valid = compare(left, right)
    return compare(remainder1, remainder2) if is_valid.nil?

    is_valid

  when class_match(pair, [Numeric, Array])
    compare([Array(left), *remainder1], packet2)
  when class_match(pair, [Array, Numeric])
    compare(packet1, [Array(right), *remainder2])
  end
end

def class_match(pair, classes)
  pair.zip(classes).all? { |obj, klass| obj.is_a? klass }
end

def step2(example = false)
  @dividers = [[[2]], [[6]]]
  input = example == 'example' ? @input_example : @input
  @values = []
  setup2(input)

  go_again

  p (@values.index(@dividers[0]) + 1) * (@values.index(@dividers[1]) + 1)
end

def setup2(input)
  input.each do |line|
    next if line.strip == ''

    @values << JSON.parse(line.strip)
  end
end

def go_again
  @values += @dividers
  @values = @values.sort { |*pair| compare(*pair) ? -1 : 1 }
end
