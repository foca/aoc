struct Point
  property x, y

  def self.parse(string)
    x, y = string.split(",").map(&.to_i)
    new(x.to_i, y.to_i)
  end

  def initialize(@x : Int32, @y : Int32)
  end
end

struct Segment
  property p1, p2

  def initialize(@p1 : Point, @p2 : Point)
  end

  def each
    if horizontal?
      (min_x..max_x).each { |x| yield Point.new(x, min_y) }
    elsif vertical?
      (min_y..max_y).each { |y| yield Point.new(min_x, y) }
    else
      x = p1.x.step(to: p2.x).to_a
      y = p1.y.step(to: p2.y).to_a
      x.zip(y) { |x, y| yield Point.new(x, y) }
    end
  end

  def horizontal?
    p1.y == p2.y
  end

  def vertical?
    p1.x == p2.x
  end

  def max_x
    [p1.x, p2.x].max
  end

  def min_x
    [p1.x, p2.x].min
  end

  def max_y
    [p1.y, p2.y].max
  end

  def min_y
    [p1.y, p2.y].min
  end
end

struct Grid
  property rows, cols
  property cells : Array(Array(Int32))

  def initialize(@rows : Int32, @cols : Int32)
    @cells = (0..@rows).map { (0..@cols).map { 0 } }
  end

  def each
    @cells.each.with_index do |row, y|
      row.each.with_index do |value, x|
        yield Point.new(x, y)
      end
    end
  end

  def mark(point : Point)
    @cells[point.y][point.x] += 1
  end

  def dangerous_areas
    @cells.sum { |row| row.count { |cell| cell >= 2 } }
  end
end

segments = ARGF.each_line
  .map { |line| line.split(/\s*->\s*/) }
  .map { |data| data.map { |coord| Point.parse(coord) } }
  .map { |pair| Segment.new(pair.first, pair.last) }
  .to_a

grid = Grid.new(segments.max_by(&.max_y).max_y, segments.max_by(&.max_x).max_x)
segments.each { |segment| segment.each { |point| grid.mark(point) } }

puts grid.dangerous_areas
