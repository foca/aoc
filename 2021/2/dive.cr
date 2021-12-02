aim = horizontal = depth = 0

ARGF.each_line do |line|
  instruction = line.split(" ")
  dir, units = instruction[0], instruction[1].to_i

  case dir
  when "down"
    aim += units
  when "up"
    aim -= units
  when "forward"
    horizontal += units
    depth += aim * units
  end
end

puts horizontal * depth
