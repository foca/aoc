diagnostic_report = ARGF.each_line

def count_bits(reported_bits)
  reported_bits
    .map { |bits| bits.chars }
    .transpose
    .map { |digits| digits.tally }
end

def bit_frequency(bit_counts, &freq : Array(Int32) -> Int32)
  bitset = bit_counts.map do |bit_count|
    sought_value = freq.call(bit_count.values)
    matching_keys = bit_count.keys.select { |key| bit_count[key] == sought_value }
    freq.call(matching_keys.map(&.to_i))
  end

  bitset.join
end

def calculate_rating(reported_bits, significant_bit = 0, &freq : Array(Int32) -> Int32)
  return reported_bits.first.to_i(2) if reported_bits.one?

  mask = bit_frequency(count_bits(reported_bits), &freq)
  calculate_rating(
    reported_bits.select { |bits| bits[significant_bit] == mask[significant_bit] },
    significant_bit + 1,
    &freq
  )
end

reported_bits = diagnostic_report.map { |line| line.chomp }.to_a

bit_counts = count_bits(reported_bits)
gamma_rate = bit_frequency(bit_counts, &.max).to_i(2)
epsilon_rate = bit_frequency(bit_counts, &.min).to_i(2)
puts sprintf("Power consumption: %d", gamma_rate * epsilon_rate)

oxygen_generator_rating = calculate_rating(reported_bits, &.max)
co2_scrubber_rating = calculate_rating(reported_bits, &.min)
puts sprintf("Life support rating: %d", oxygen_generator_rating * co2_scrubber_rating)
