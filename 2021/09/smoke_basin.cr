locations = ARGF.each_line.map { |line| line.chomp.chars.map(&.to_i) }.to_a

alias Coord = Tuple(Int32, Int32)

low_points = [] of Tuple(Coord, Int32)

def adjacent(x, y, map) : Array(Coord)
  max_y = map.size
  max_x = map.first.size

  [
    {x - 1, y},
    {x + 1, y},
    {x, y - 1},
    {x, y + 1}
  ].select { |(x, y)| (0...max_x).includes?(x) && (0...max_y).includes?(y) }
end

def basin_size_for(coord, map)
  coords = [] of Coord
  visited = Set(Coord).new

  coords << coord

  while coords.any?
    x, y = coords.shift
    next if map[y][x] == 9 || visited.includes?({x,y})
    coords.concat(adjacent(x, y, map))
    visited << {x,y}
  end

  visited.size
end

locations.each.with_index do |row, y|
  row.each.with_index do |height, x|
    low_points << {Coord.new(x, y), height} if adjacent(x, y, locations).all? { |(dx, dy)| locations[dy][dx] > height }
  end
end

puts sprintf("Part 1: %d", low_points.sum { |(_, height)| 1 + height })

biggest_basins = low_points
  .map { |(coord, _)| basin_size_for(coord, locations) }
  .sort
  .last(3)

puts sprintf("Part 2: %d", biggest_basins.reduce(1) { |total, size| total * size })
