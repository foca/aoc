days_to_simulate = (ARGV.first? || "80").to_i
fish = STDIN.gets_to_end.split(",").map(&.to_i8)

# This calculates the population growth for a starting population of a single
# fish that reproduces on the first day. (i.e. initial pop is 2, one adult and
# one newborn).
#
# The growth, then, can be calculated as P(x) = P(x - 7) + P(x - 9), since the
# fish that starts as an adult will have a newborn every 7 day, and these will
# start having babies 9 days afterward.
#
# We can calculate this once, and then just calculate the offset based on the
# initial age of each input fish to determine how many fish that one contributes
# to the population.
def population_size_after(days)
  population = [2, 2, 2, 2, 2, 2, 2, 3, 3] of Int128

  (9...days).each do |day|
    population.push population[day - 7] + population[day - 9]
  end

  population
end

pop_sizes = population_size_after(days_to_simulate)
puts fish.sum { |initial_age| pop_sizes[days_to_simulate - (initial_age + 1)] }
