def winner?(board)
  rows = [(0..4).to_a, (5..9).to_a, (10..14).to_a, (15..19).to_a, (20..24).to_a]
  cols = rows.transpose

  [*rows, *cols].find { |indices| indices.all? { |idx| board[idx].nil? } }
end

def score(board, number)
  board.compact.sum * number
end

prng = ARGF.gets.to_s.split(",").map(&.to_i)

boards : Array(Array(Int32 | Nil)) = ARGF.gets_to_end.split("\n\n")
  .map { |board| board.split(/\s+/).reject(&.empty?).map(&.to_i?) }

winners = [] of Array(Int32 | Nil)

prng.each do |number|
  boards.each do |board|
    board.each.with_index do |elem, index|
      board[index] = nil if elem == number
    end

    # First winner (nothing in the winners list) is the first score.
    puts sprintf("Winning score: %d", score(board, number)) if winner?(board) && winners.empty?

    # Cache every winning board
    winners << board if winner?(board) && !winners.includes?(board)

    # If all boards are winners, then we've just marked the last winning board
    if winners.size == boards.size
      puts sprintf("Losing score: %d", score(board, number))
      exit 0
    end
  end
end
