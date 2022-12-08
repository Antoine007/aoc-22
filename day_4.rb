def step1(example = false)
  input = example == 'example' ? @input_example : @input
  count = 0
  input.each do |line|
    split = line.strip.split(",")
    a,b = split[0].split("-")
    c,d = split[1].split("-")

    # p [first,second]
    if a.to_i <= c.to_i && b.to_i >= d.to_i
      p [a,b,c,d]
      count += 1
      next
    end
    if c.to_i <= a.to_i && d.to_i >= b.to_i
      count += 1
      p [a,b,c,d]
      p "XXXX"
      next
    end
  end
  p count
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
  count = 0
  input.each do |line|
    split = line.strip.split(",")
    a,b = split[0].split("-")
    c,d = split[1].split("-")

    count += 1 unless b.to_i < c.to_i || d.to_i < a.to_i
  end
  p count
end
