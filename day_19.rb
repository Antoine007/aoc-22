require 'set'

Blueprint = Struct.new(:id, :ore, :clay, :obsidian_ore, :obsidian_clay, :geode_ore, :geode_obsidian)
BotState = Struct.new(:minutes,
                      :ore_bots, :clay_bots, :obs_bots, :geode_bots,
                      :ore, :clay, :obs, :geode)

def step1(example = false)
  input = example == 'example' ? @input_example : @input
  blueprints = make_blueprints(input)

  sum = blueprints.map do |bp|
    get_best_geodes(bp, 24) * bp.id
  end.sum
  p sum
end

def make_blueprints(input)
  input.map do |line|
    numbers = line.strip.split(/[^\d]/).select { |a| a.to_i.positive? }.map(&:to_i)
    blueprint, ore, clay, obsidian_ore, obsidian_clay, geode_ore, geode_obsidian = numbers
    Blueprint.new(blueprint, ore, clay, obsidian_ore, obsidian_clay, geode_ore, geode_obsidian)
  end
end

def step2(example = false)
  input = example == 'example' ? @input_example : @input
end

def get_best_geodes(bp, minutes)
  best = 0
  queue = [BotState.new(minutes, 1, 0, 0, 0, 0, 0, 0, 0)]
  visited = Set.new
  while queue.size.positive?
    curr = queue.shift
    next if visited.include?(curr)

    visited << curr
    if curr.minutes.zero?
      best = curr.geode if best < curr.geode
    else
      n = BotState.new(
        curr.minutes - 1,
        curr.ore_bots,
        curr.clay_bots,
        curr.obs_bots,
        curr.geode_bots,
        curr.ore + curr.ore_bots,
        curr.clay + curr.clay_bots,
        curr.obs + curr.obs_bots,
        curr.geode + curr.geode_bots
      )

      can_build_geode = (curr.ore >= bp.geode_ore && curr.obs >= bp.geode_obsidian)
      # don't build obs bot if you can build geode bot
      # don't need more obs than 1 geodeBot per min
      can_build_obs = !can_build_geode &&
                      (curr.obs_bots < bp.geode_obsidian) &&
                      (curr.ore >= bp.obsidian_ore && curr.clay >= bp.obsidian_clay)
      # don't build clay bot if you can build geode bot
      # don't need more clay than 1 obsBot per min
      can_build_clay = !can_build_geode &&
                       !can_build_obs &&
                       (curr.clay_bots < bp.obsidian_clay) &&
                       (curr.ore >= bp.obsidian_clay)
      # don't need more ore than the max any bot could need per min
      can_build_ore = !can_build_geode && !can_build_obs &&
                      (curr.ore_bots < [bp.geode_ore, bp.obsidian_ore, bp.obsidian_clay].max) &&
                      (curr.ore >= bp.ore)
      # don't want to hoard if we can build a a geode bot
      cant_build = !can_build_geode &&
                   (curr.ore < 2 * [bp.geode_ore, bp.obsidian_ore, bp.obsidian_clay].max) &&
                   (curr.clay < 3 * bp.obsidian_clay)

      queue << n if cant_build

      # push build geode bot state
      queue << BotState.new(
        n.minutes,
        n.ore_bots,
        n.clay_bots,
        n.obs_bots,
        n.geode_bots + 1,
        n.ore - bp.geode_ore,
        n.clay,
        n.obs - bp.geode_obsidian,
        n.geode
      ) if can_build_geode

      # push build obs bot state
      queue << BotState.new(
        n.minutes,
        n.ore_bots,
        n.clay_bots,
        n.obs_bots + 1,
        n.geode_bots,
        n.ore - bp.obsidian_ore,
        n.clay - bp.obsidian_clay,
        n.obs,
        n.geode
      ) if can_build_obs

      # push build clay bot state
      queue << BotState.new(
        n.minutes,
        n.ore_bots,
        n.clay_bots + 1,
        n.obs_bots,
        n.geode_bots,
        n.ore - bp.obsidian_clay,
        n.clay,
        n.obs,
        n.geode
      ) if can_build_clay

      # push build ore bot state
      queue << BotState.new(
        n.minutes,
        n.ore_bots + 1,
        n.clay_bots,
        n.obs_bots,
        n.geode_bots,
        n.ore - bp.ore,
        n.clay,
        n.obs,
        n.geode
      ) if can_build_ore
    end
  end
  best
end
