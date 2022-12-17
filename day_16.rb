require 'set'

def step1(example = false)
  input = example == 'example' ? @input_example : @input
  @valves = {}
  @current_valve = nil
  parse_valves(input)
  @good_valves = @valves.select {|_k, hash| hash[:flow] > 0 }.keys
  # p @current_valve
  calculate_distances
  p @valves
  calculate_flow
end

def parse_valves(input)
  input.each do |line|
    valve, leading = line.strip.split('; ')
    valve_name, flow = valve.split(' has flow rate=')
    valve_name = valve_name[6..]
    flow = flow.to_i
    leading = leading[22..]
    leading = leading.split(', ').collect(&:strip)
    @current_valve = valve_name if @valves.length.zero?
    distances = {}
    leading.each { |to| distances[to] = 1 }
    @valves[valve_name] = { flow:, leading:, distances: }
  end
end

def calculate_distances
  @valves.each do |valve, hash|
    until hash[:distances].count >= @good_valves.count - 1
      populate_distances(valve, hash[:distances])
    end
  end
  p @valves
end

def populate_distances(valve, distances)
  @good_valves.each do |v|
    next if valve == v
    next if distances.keys.include? v
    next unless @good_valves.include? v

    @valves[valve][:distances][v] = valve_distance(valve, v)
  end
end

def valve_distance(start, out)
  return 0 if start == out

  seen = Set.new
  seen << start
  to_visit = []
  @valves[start][:leading].each do |xit|
    seen << xit
    to_visit << [xit, 1]
  end
  while to_visit.length > 0
    valve, steps = to_visit.shift
    return steps if valve == out

    @valves[valve][:leading].each do |xit|
      next if seen.include? xit

      seen << xit
      to_visit << [xit, steps + 1]
    end
  end
end

def calculate_flow
  # TODO: dig
  initial_state = { minute: 1, position: "AA", opened: [], rate: 0, total: 0 }
  max_flow = 0
  states = [initial_state]

  until states.length == 0
    state = states.shift
    max_flow = [max_flow, flow(state)].max
    valve = @valves[state[:position]]

    next if state[:minute] == 30

    if (state[:opened].include? state[:position]) == false && valve[:flow] > 0
      states << {
        minute: state[:minute] + 1,
        position: state[:position],
        opened: state[:opened] << state[:position],
        rate: state[:rate] + valve[:flow],
        total: state[:total] + state[:rate]
      }
      next
    end
    @good_valves.each do |v|
      next if state[:opened].include? v

      distance = @valves[state[:position]][:distances][v]

      next if state[:minute] + distance > 29

      states << {
        minute: state[:minute] + distance,
        position: v,
        opened: state[:opened],
        rate: state[:rate],
        total: state[:total] + (state[:rate] * distance)
      }
    end
    p state
  end
  p max_flow
end

def flow(state, time = 30)
  state[:total] + (time - state[:minute] + 1) * state[:rate]
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
end
