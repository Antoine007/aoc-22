def step1(example = false)
  input = example == 'example' ? @input_example : @input

  elvish_totals = []
  elf_total = 0

  input.each do |line|
    if line == "\n"
      elvish_totals << elf_total
      elf_total = 0
    else
      elf_total += line.gsub('\n', '').to_i
    end
  end
  p elvish_totals.max
end

def step2(example = false)

  # .max(3).sum
  input = example == 'example' ? @input_example : @input
end

# p step1('example')
# p step2('example')

p step1
# p step2
