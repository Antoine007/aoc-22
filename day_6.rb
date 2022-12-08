def step1(example = false)
  input = example == 'example' ? @input_example : @input

  index = 0
  letters = input[0].strip.split('')
  # p letters[index..index + 3]
  success = false
  until success
    index += 1
    # p letters[index..index + 3].uniq.length
    success = true if letters[index..index + 3].uniq.length == 4
  end
  p index + 4
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input

  index = 0
  letters = input[0].strip.split('')
  # p letters[index..index + 3]
  success = false
  until success
    index += 1
    # p letters[index..index + 3].uniq.length
    success = true if letters[index..index + 13].uniq.length == 14
  end
  p index + 14
end
