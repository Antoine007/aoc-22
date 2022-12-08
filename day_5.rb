def step1(example = false)
  input = example == 'example' ? @input_example : @input
  make_initial_stack(example)

  input.each do |line|
    next unless line[0..3] == "move"

    pattern = /move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)$/
    match_data = line.match(pattern)
    match_data[:count].to_i.times do
      # p @stack[match_data[:from].to_sym]
      crate = @stack[match_data[:from].to_sym].pop
      @stack[match_data[:to].to_sym] << crate
    end
  end
  result = ""
  @stack.values.each{|array| result += array.last}
  p result.upcase
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
  make_initial_stack(example)

  input.each do |line|
    next unless line[0..3] == "move"

    pattern = /move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)$/
    match_data = line.match(pattern)


    crates = @stack[match_data[:from].to_sym].pop(match_data[:count].to_i)
    @stack[match_data[:to].to_sym].concat(crates)

  end
  result = ""
  @stack.values.each{|array| result += array.last}
  p result.upcase
end

def make_initial_stack(example = false)

  @stack = example ?
  {
    "1": %w[z n],
    "2": %w[m c d],
    "3": %w[p],
  } :
  {
  "1": %w[r g h q s b t n],
  "2": %w[h s f d p z j],
  "3": %w[z h v],
  "4": %w[m z j f g h],
  "5": %w[t z c d l m s r],
  "6": %w[m t w v h z j],
  "7": %w[t f p l z],
  "8": %w[q v w s],
  "9": %w[w h l m t d n c]
}
end
