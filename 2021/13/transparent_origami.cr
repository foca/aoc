require "../lib/map"

class Foldable < Map(String)
  def initialize(dots : Array(Array(Int32)))
    horizontal, vertical = dots.transpose
    cols = horizontal.max + 1
    rows = vertical.max + 1

    initialize((0...rows).map { ["."] * cols })
    dots.each { |(x,y)| self[x,y] = "#" }
  end

  def fold(xy, index)
    case xy
    when "x"
      fold_x(index)
    when "y"
      fold_y(index)
    end

    self
  end

  def fold_x(x : Int32)
    @data.each.with_index do |row, y|
      row[x...cols].each.with_index do |coord, i|
        self[x - i, y] = "#" if coord.value == "#"
      end

      row.delete_at(x...cols)
    end
  end

  def fold_y(y : Int32)
    @data[y...rows].each.with_index do |folded, i|
      folded.each do |coord|
        self[coord.x, y - i] = "#" if coord.value == "#"
      end
    end

    @data.delete_at(y...rows)
  end
end

dots = ARGF.each_line
  .take_while { |line| line.includes?(",") }
  .map { |line| line.split(",").map(&.to_i) }
  .to_a

folds = ARGF.each_line
  .take_while { |line| line =~ /[xy]=\d+/ }
  .map { |line| line.split.last.split("=", 2) }
  .map { |(dir, at)| {dir, at.to_i} }
  .to_a

first_fold = folds.shift

map = Foldable.new(dots).fold(*first_fold)
puts sprintf("Part 1: %d", map.each.count { |pos| pos.value == "#" })

puts "Part 2:"
pp folds.reduce(map) { |grid, (dir, at)| grid.fold(dir, at) }
