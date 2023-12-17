#!/usr/bin/env ruby

require 'pry'
require_relative 'aoc2023-3'  # provides AocConfig

test_data = <<-END
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
END

class ConditionRecord
  attr_reader :string, :numbers
  STATUSES = {
    operational: '.',
    damaged:     '#',
    unknown:     '?',
  }
  def initialize(line)
    @string, numbers = line.chomp.split
    @numbers = numbers.split(/,/).map(&:to_i)
  end
  def permutation_count
    2 ** string.scan(STATUSES[:unknown]).count
  end
  def each_raw
    return enum_for(:each_raw) unless block_given?
    (0...permutation_count).each do |i|
      j = -1
      s = string.gsub('?') {|m| j += 1; i.allbits?(1 << j) ? '#' : '.' }
      binding.pry if s.length != string.length
      yield s
    end
  end
  def each_valid
    return enum_for(:each_valid) unless block_given?
    each_raw do |s|
      yield s if s.scan(/#+/).map(&:length) == numbers
    end
  end
end

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  if config.part == 1
    records = config.data.lines.map {|line| ConditionRecord.new(line) }
    # p records
    total_permutations = records.map(&:permutation_count).sum
    p({total_permutations:})
    # p records[1].each_raw.to_a
    # p records[1].each_valid.to_a
    t0 = Time.now
    arrangements = records.map {|record|
      # p record.each_raw.to_a
      # p record.each_valid.to_a
      record.each_valid.count
    }
    p arrangements
    p arrangements.sum
    p Time.now - t0

    # better: length, gaps
  elsif config.part == 2
    raise NotImplementedError
  end
end
