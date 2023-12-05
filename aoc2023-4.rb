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

class Scratchcard
  attr_reader :card_number, :winning_numbers, :numbers_you_have
  def initialize(line)
    match = /Card (?<n>.*): (?<winning>.*) \| (?<youhave>.*)/.match(line)
    @card_number = match[:n].to_i
    @winning_numbers = match[:winning].split.map(&:to_i)
    @numbers_you_have = match[:youhave].split.map(&:to_i)
  end
  def overlap
    (winning_numbers & numbers_you_have).count
  end
  def points
    points = 2 ** (overlap - 1) if overlap.positive?
  end
end

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  cards = config.data.lines.map {|line| Scratchcard.new(line) }
  if config.part == 1
    card_values = cards.map(&:points)
    p card_values
    p card_values.compact.sum
  elsif config.part == 2
    copy_counts = Hash.new { 1 }
    cards.each_with_index do |card, i|
      copies_of_this_card = copy_counts[card.card_number]
      puts "Card #{card.card_number}: #{copies_of_this_card} copies, overlap: #{card.overlap}"
      card.overlap.to_i.times do |j|
        n = card.card_number + j + 1
        copy_counts[n] += copies_of_this_card
        puts "  Winning #{copies_of_this_card} more of card #{n} for a total of #{copy_counts[n]}"
      end
    end
    count = cards.map {|card| copy_counts[card.card_number] }
    p count
    p count.sum
  end
end
