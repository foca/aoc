template = ARGF.gets.to_s.chars.to_a
rules = ARGF.each_line
  .select { |line| line =~ /->/ }
  .map { |line| line.split(" -> ") }
  .to_h

alias Counter = Hash(String, Int128)

def polymerize(template, rules, steps = 10)
  per_pair = Counter.new(0)
  template.each_cons(2) { |pair| per_pair[pair.join] += 1 }

  steps.times do
    next_totals = Counter.new(0)

    per_pair.each do |pair, count|
      element = rules[pair]
      next_totals[pair[0] + element] += count
      next_totals[element + pair[1]] += count

      per_pair = next_totals
    end
  end

  per_letter = Counter.new(0)
  per_pair.each { |pair, count| per_letter[pair[0].to_s] += count }
  per_letter[template[-1].to_s] += 1

  min, max = per_letter.values.minmax
  max - min
end

puts sprintf("Part 1: %d", polymerize(template, rules, 10))
puts sprintf("Part 2: %d", polymerize(template, rules, 40))
