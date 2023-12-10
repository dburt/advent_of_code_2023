#!/usr/bin/env ruby

require_relative 'aoc2023-3'  # provides AocConfig

test_data = <<-END
Time:      7  15   30
Distance:  9  40  200
END

# t: time limit; r: distance record
# d: distance; b: button time, v: velocity
# v = b
# d = v * (t - b)
# d = b * (t - b)
# d = -b^2 + tb  # t=7: b=0 d=0; 1 6; 2 10; 3 12; 4 12
# b E N
# win: d > r
# r < -b^2 + tb
# 0 < -b^2 + tb - r
# quadratic formula: x = (-b +- (b2-4ac))/(2a)
# where a = -1, b = t, c = -r
# intersections where: b = (-t +- sqrt(t^2 - 4(t * -r)))) / -2
# intersections where: b = (-t +- sqrt(t^2 + 4tr))) / -2

def factor_quadratic(a:, b:, c:)
  [
    (-b + Math.sqrt((b**2)-4*a*c))/(2*a),
    (-b - Math.sqrt((b**2)-4*a*c))/(2*a),
  ]
end

class Float
  def integer?
    self == to_i
  end
end

def count_integer_winning_button_times(t:, r:)
  d = factor_quadratic(a: -1, b: t, c: -r)
  n = (d[0].ceil..d[1].floor).count
  n -= 1 if d[0].integer?
  n -= 1 if d[1].integer?
  p [d, n]
  n
end

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  if config.part == 1
    times, distances = config.data.lines.map {|line| line.scan(/\d+/).map(&:to_i) }
    ways_to_win_each_race = times.zip(distances).map do |t, r|
      count_integer_winning_button_times(t:, r:)
    end
    total_ways_to_win = ways_to_win_each_race.inject(&:*)
    p({ways_to_win_each_race:, total_ways_to_win:})
  elsif config.part == 2
    raise NotImplementedError, "waiting for revelation"
  end
end
