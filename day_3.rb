@letter_to_number = ('a'..'z').zip(1..26).to_h
("A".."Z").each_with_index do |letter, index|
  @letter_to_number[letter] = index + 27
end

def step1(example = false)
  input = example == 'example' ? @input_example : @input
  items = []
  result = 0
  input.each{ |line| items << [line.strip[0..line.length / 2], line.strip[line.length / 2..line.length]] }
  items.each{|item|  result += @letter_to_number[(item[0].split("") & item[1].split(""))[0]] }
  p result
  # input.each do |line|

  # end
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
  items = []

  # find group by 3 method
  input.each_slice(3) do |group|
    first = group[0].strip.split("").uniq.join("")
    second = group[1].strip
    third = group[2].strip
    first.split("").each do |letter_index|
      items << @letter_to_number[first[letter_index]] if second.include?(first[letter_index]) && third.include?(first[letter_index])
    end
  end
  p items.sum
end
