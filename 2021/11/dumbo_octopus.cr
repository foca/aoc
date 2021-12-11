require "../lib/map"

class Octopus
  property energy, flashes = 0

  def initialize(@energy : Int32)
    @flashed_this_turn = @flashed_last_turn = false
  end

  def flashed_last_turn?
    @flashed_last_turn
  end

  def flashed_this_turn?
    @flashed_this_turn
  end

  def charge
    @energy += 1
  end

  def flash : Bool
    return false if @flashed_this_turn || @energy <= 9

    @flashes += 1
    @flashed_this_turn = true
  end

  def reset
    @flashed_last_turn = @flashed_this_turn
    @flashed_this_turn = false
    @energy = 0 if @energy > 9
  end

  def inspect
    sprintf("%2d%s", energy, flashed_this_turn? ? "!" : ".")
  end
end

class OctoMap < Map(Octopus)
  def increase_energy(octopi = to_a, visited = Set(Octopus).new)
    return if visited.proper_superset_of?(octopi.to_set)

    octopi.each(&.value.energy += 1)

    octopi.each do |coord|
      octopus = coord.value

      if octopus.flash
        visited.add(octopus)
        increase_energy(neighbors(coord, diagonal: true), visited)
      end
    end
  end

  def reset
    to_a.each(&.value.reset)
  end
end

input = ARGF.gets_to_end

part_1 = OctoMap.parse(input) { |char| Octopus.new(char.to_i) }
part_2 = OctoMap.parse(input) { |char| Octopus.new(char.to_i) }

100.times do
  part_1.increase_energy
  part_1.reset
end

puts sprintf("Part 1: %d", part_1.to_a.sum(&.value.flashes))

turn = 0
until part_2.each.all?(&.value.flashed_last_turn?)
  turn += 1
  part_2.increase_energy
  part_2.reset
end

puts sprintf("Part 2: %d", turn)
