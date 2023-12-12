#!/usr/bin/env ruby

require_relative 'aoc2023-3'  # provides AocConfig

test_data = <<-END
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
END

class String
  def scan_integers
    scan(/[-\d]+/).map(&:to_i)
  end
end

class Array
  def differences
    (0...(length - 1)).map do |i|
      self[i+1] - self[i]
    end
  end
end

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  if config.part == 1
    histories = config.data.lines.map(&:scan_integers)
    predictions = histories.map do |history|
      diffs = [history]
      while not diffs.last.all?(&:zero?)
        diffs << diffs.last.differences
      end
      # diffs.reverse.inject(0) do |memo, diff|
      #   memo + (diff.last || 0)
      # end
      diffs.map(&:last).compact.sum

    end
    p predictions
    p predictions.sum
    # 1938255807 is too high
  elsif config.part == 2
    raise NotImplementedError
  end
end
