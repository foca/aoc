navigation = ARGF.each_line.to_a

OPENING = Set(Char).new ['(', '[', '{', '<']
CLOSING = Set(Char).new [')', ']', '}', '>']

PAIRS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>',
}

CORRUPTION_SCORE = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137,
}

COMPLETENESS_SCORE = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4,
}

corruption_score = 0

scores = navigation.compact_map do |line|
  state = {
    '(' => 0,
    '[' => 0,
    '{' => 0,
    '<' => 0,
  }

  stack = [] of Char
  corrupted = false

  line.chars.each do |char|
    if OPENING.includes?(char)
      stack.push(char)
    elsif stack.any? && PAIRS[stack.last] == char
      stack.pop
    else
      corruption_score += CORRUPTION_SCORE[char]
      corrupted = true
      break
    end
  end

  next if corrupted

  stack.reverse
    .reduce(Int128.new(0)) { |score, char| score * 5 + COMPLETENESS_SCORE[char] }
end

puts sprintf("Part 1: %d", corruption_score)
puts sprintf("Part 2: %d", scores.sort[scores.size // 2])
