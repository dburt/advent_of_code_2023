#!/usr/bin/env ruby

require_relative 'aoc2023-3'  # provides AocConfig

test_data = <<-END
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
END

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  card_values = config.data.lines.map do |line|
    match = /Card .*: (?<winning>.*) \| (?<youhave>.*)/.match(line)
    winning_numbers = match[:winning].split.map(&:to_i)
    numbers_you_have = match[:youhave].split.map(&:to_i)
    overlap = (winning_numbers & numbers_you_have).count
    points = 2 ** (overlap - 1) if overlap.positive?
  end
  puts
  p card_values
  p card_values.compact.sum
end
