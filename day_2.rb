@win_score = { "A X": 3, "B Y": 3, "C Z": 3, "B X": 0, "C X": 6, "A Y": 6, "C Y": 0, "A Z": 0, "B Z": 6 }
@pick_score = { "X": 1, "Y": 2, "Z": 3 }

# X draw Y lose Z win
@point_per_pick = { "R": 1, "P": 2, "S": 3 }
@win_score = { "X": 0, "Y": 3, "Z": 6 }
@pick_finder = { "A X": "S", "B X": "R", "C X": "P", "A Y": "R", "B Y": "P", "C Y": "S", "A Z": "P", "B Z": "S", "C Z": "R" }

def step1(example = false)
  input = example == 'example' ? @input_example : @input
  results = []
  input.each do |line|
    score = @pick_score[line[2].to_sym] + @win_score[line.strip.to_sym]
    results << score
  end
  p results.sum
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input

  results = []
  input.each do |line|
    pick = @pick_finder[line.strip.to_sym]
    score = @win_score[line[2].to_sym] + @point_per_pick[pick.to_sym]
    results << score
  end
  p results.sum
end
