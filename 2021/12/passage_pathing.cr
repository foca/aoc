nodes = Hash(String, Array(String)).new { |hash, name| hash[name] = [] of String }

ARGF.each_line do |line|
  source, target = line.split("-")
  nodes[source] << target
  nodes[target] << source
end

def count_paths(nodes, current, visited = Array(String).new, allow_one_double = false)
  return 1 if current == "end"

  if current.downcase == current && visited.includes?(current)
    counts = visited.tally
    return 0 if counts.values.max > 1
    return 0 if !allow_one_double || current == "start"
  end

  visited += [current] if current.downcase == current
  nodes[current].sum { |neighbor| count_paths(nodes, neighbor, visited, allow_one_double) }
end

puts sprintf("Part 1: %d", count_paths(nodes, "start"))
puts sprintf("Part 2: %d", count_paths(nodes, "start", allow_one_double: true))
