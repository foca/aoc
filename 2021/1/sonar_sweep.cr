# Run as "bin/sonar_sweep 1" for part 1 (no roll-up, so window size is 1) and
# "bin/sonar_sweep 3" for part 2 (roll up 3 entries at a time).

depths = STDIN.each_line.map { |line| line.to_i }.to_a
window_size = (ARGV.first? || 3).to_i

def aggregated_depths(depths, window_size=3)
  depths.each_cons(window_size).map(&.sum).to_a
end

puts aggregated_depths(depths, window_size)
  .each_cons(2)
  .count { |pair| pair.last > pair.first }
