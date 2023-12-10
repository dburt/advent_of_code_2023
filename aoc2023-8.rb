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

test_data = <<-END
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
END

if __FILE__ == $0
  config = AocConfig.new(test_data:)
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
  if config.part == 1
    path = ['AAA']
    i = 0
    until path.last == 'ZZZ'
      left_or_right = instructions[i % instructions.length]
      path << network[path.last][left_or_right]
      i += 1
      p [i, left_or_right, path.last]
    end
    p i
  elsif config.part == 2
    nodes = network.keys.grep(/A$/)
    p nodes
    i = 0
    until nodes.all? {|node| node.end_with? 'Z' }
      left_or_right = instructions[i % instructions.length]
      nodes.map! {|node| network[node][left_or_right] }
      i += 1
      p [i, left_or_right, nodes]
      # too slow: need to identify cycle time for each path and find LCM
    end
    p i
  end
end
