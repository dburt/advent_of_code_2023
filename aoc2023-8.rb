#!/usr/bin/env ruby

require_relative 'aoc2023-3'  # provides AocConfig

test_data = <<-END
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
END

test_data = <<-END
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
END

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  if config.part == 1
    instructions = nil
    network = {}
    config.data.lines.each do |line|
      case line
      when /^[RL]+$/
        instructions = line.chomp.tr('LR', '01').chars.map(&:to_i)
      when /^(\w+) = \((\w+), (\w+)\)/
        network[$1] = [$2, $3]
      end
    end
    p [instructions, network]
    path = ['AAA']
    i = 0
    until path.last == 'ZZZ'
      left_or_right = instructions[i % instructions.length]
      path << network[path.last][left_or_right]
      i += 1
      p [i, left_or_right, path.last]
    end
    p path.length - 1
  elsif config.part == 2
    raise NotImplementedError
  end
end
