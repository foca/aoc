crabs = ARGF.gets_to_end.split(",").map(&.to_i)

def fuel_consumption(crab, target)
  distance = (crab - target).abs
  (distance * (distance + 1) // 2).to_i128
end

ordered_crabs = crabs.sort

min_consumption : Int128 = 999999999

(0..ordered_crabs.max).each do |pivot|
  consumption = ordered_crabs.sum { |c| fuel_consumption(c, pivot) }
  min_consumption = consumption if consumption < min_consumption
end

puts min_consumption
