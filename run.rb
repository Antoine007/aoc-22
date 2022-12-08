day = Time.new.day

# chomp removes blank lines
@input_example = IO.readlines("data-#{day}-example.txt", chomp: false)
@input = IO.readlines("data-#{day}.txt", chomp: false)

require_relative "day_#{day}"

step1('example')
# step1

# step2('example')
# step2
