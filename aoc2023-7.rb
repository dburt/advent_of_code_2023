#!/usr/bin/env ruby

require_relative 'aoc2023-3'  # provides AocConfig

test_data = <<-END
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
END

card_values = %w(A K Q J T 9 8 7 6 5 4 3 2).reverse
tally = ->(hand) { hand.tally.values.sort.reverse }
cvs = ->(hand) { hand.map {|c| card_values.index(c) } }
hand_types = [
  ->(hand) { 5 if hand.uniq.count == 1 },
  ->(hand) { ns = tally[hand]; 4   if ns[0] == 4 },
  ->(hand) { ns = tally[hand]; 3.5 if ns[0] == 3 && ns[1] == 2 },
  ->(hand) { ns = tally[hand]; 3   if ns[0] == 3 },
  ->(hand) { ns = tally[hand]; 2.5 if ns[0] == 2 && ns[1] == 2 },
  ->(hand) { ns = tally[hand]; 2   if ns[0] == 2 },
  ->(hand) { 1 },
]
px = ->(x) { p x }
best_hand_type = ->(hand) { hand_types.each {|ht| t = ht[hand]; break t if t } }
hand_value = ->(hand) { ([best_hand_type[hand]] + cvs[hand]).tap(&px) }
parse_line = ->(line) { hand, bid = line.scan(/[\w\d]+/); [hand.chars, bid.to_i] }

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  if config.part == 1
    records = config.data.lines.map(&parse_line)
    records.sort_by! {|hand, bid| hand_value[hand] }
    ranks = (1..)
    p [records, ranks]
    p records.zip(ranks).map {|(hand, bid), rank| bid * rank }.sum
  elsif config.part == 2
    raise NotImplementedError
  end
end
