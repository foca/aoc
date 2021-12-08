lines = ARGF.each_line.to_a

#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....
# 
#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg
#
#
# number of segments => possible numbers
#
# 2 => [1],
# 3 => [7],
# 4 => [4],
# 5 => [2, 3, 5],
# 6 => [0, 6, 9],
# 7 => [8],

# Part 1
puts sprintf("Part 1: %d", lines
  .map { |line| line.split("|").last }
  .flat_map { |val| val.split(/\s+/) }
  .select { |num| [2, 3, 4, 7].includes?(num.size) }
  .size)

# Part 2
total = lines.sum do |line|
  key, number = line.split("|").map { |val| val.split(/\s+/).map(&.chars).reject(&.empty?) }

  one = key.find { |s| s.size == 2 }.as(Array)
  key.delete(one)

  seven = key.find { |s| s.size == 3 }.as(Array)
  key.delete(seven)

  four = key.find { |s| s.size == 4 }.as(Array)
  key.delete(four)

  eight = key.find { |s| s.size == 7 }.as(Array)
  key.delete(eight)

  three = key.find { |s| s.size == 5 && (s - seven).size == 2 }.as(Array)
  key.delete(three)

  two = key.find { |s| s.size == 5 && (s - four).size == 3 }.as(Array)
  key.delete(two)

  five = key.find { |s| s.size == 5 }.as(Array)
  key.delete(five)

  six = key.find { |s| s.size == 6 && (s - one).size == 5 }.as(Array)
  key.delete(six)

  nine = key.find { |s| s.size == 6 && (s - four).size == 2 }.as(Array)
  key.delete(nine)

  zero = key.first

  mappings = {
    zero.sort => 0,
    one.sort => 1,
    two.sort => 2,
    three.sort => 3,
    four.sort => 4,
    five.sort => 5,
    six.sort => 6,
    seven.sort => 7,
    eight.sort => 8,
    nine.sort => 9
  }

  number.map { |d| mappings[d.sort].to_s }.join.to_i(10)
end

puts sprintf("Part 2: %d", total)
