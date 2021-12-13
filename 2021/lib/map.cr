struct Coord(T)
  property x, y : Int32
  property value : T

  def initialize(@x : Int32, @y : Int32, @value : T)
  end

  def inspect
    value.inspect
  end
end

class Map(T)
  include Enumerable(Coord(T))
  include Iterable(Coord(T))

  getter rows : Int32
  getter cols : Int32

  @data : Array(Array(Coord(T)))

  def self.parse(input : IO | String, &entry : Char -> T)
    data = input.each_line.map { |line| line.chars.map(&entry) }
    new(data.to_a)
  end

  def initialize(data : Array(Array(T)))
    @data = data.map_with_index do |row, y|
      row.map_with_index do |val, x|
        Coord(T).new(x, y, val)
      end
    end
    @rows = data.size
    @cols = data.first.size
  end

  def [](x, y) : T
    @data[y][x].value
  end

  def []=(x,y, value : T)
    @data[y][x] = Coord(T).new(x, y, value)
  end

  def each(&block : Coord(T) ->)
    @data.flatten.each(&block)
  end

  def each
    @data.flatten.each
  end

  def neighbors(coord : Coord(T), diagonal=false) : Array(Coord(T))
    neighbors(coord.x, coord.y, diagonal)
  end

  def neighbors(x, y, diagonal=true) : Array(Coord(T))
    neighbors = [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]

    if diagonal
      neighbors.push(
        {x - 1, y - 1}, {x + 1, y - 1}, {x + 1, y + 1}, {x - 1, y + 1}
      )
    end

    neighbors
      .select { |(x, y)| x >= 0 && x < cols && y >= 0 && y < rows }
      .map { |(x, y)| @data[y][x] }
  end

  def inspect(full = false)
    map = @data
      .map { |row| row.map(&.inspect).join(" ") }
    map << "-" * map.first.chomp.size
    map.join("\n")
  end
end

