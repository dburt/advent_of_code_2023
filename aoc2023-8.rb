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

class Node < Struct.new(:name, :left, :right)
  def terminal?
    @terminal ||= name.end_with?('Z')
  end
  def left_and_right=(left_and_right)
    self.left = left_and_right.first
    self.right = left_and_right.last
  end
  def [](index)
    case index
    when 0; left
    when 1; right
    else; raise ArgumentError
    end
  end
  def inspect
    "(Node #{name} left=#{left&.name} right=#{right&.name})"
  end
end

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  instructions = nil
  network = {}
  config.data.lines.each do |line|
    case line
    when /^[RL]+$/
      instructions = line.chomp.tr('LR', '01').chars.map(&:to_i)
    when /^(\w+) = \((\w+), (\w+)\)/
      network[$1.to_sym] = [$2.to_sym, $3.to_sym]
    end
  end
  p [instructions, network] if config.dataset == 'test'
  if config.part == 1
    path = [:AAA]
    i = 0
    until path.last == :ZZZ
      left_or_right = instructions[i % instructions.length]
      path << network[path.last][left_or_right]
      i += 1
      p [i, left_or_right, path.last]
    end
    p i
  elsif config.part == 2
    linked_list = Hash.new {|h, k| h[k] = Node.new(k) }
    network.each do |name, (left, right)|
      linked_list[name].left_and_right = [linked_list[left], linked_list[right]]
      network[name] << linked_list[name]
    end
    start_node_keys = network.keys.grep(/A$/)
    start_nodes = start_node_keys.map {|key| linked_list[key] }
    p start_nodes

    paths = start_nodes.map do |start_node|
      i = 0
      path = [[0, start_node]]
      node = start_node
      loop do
        left_or_right = instructions[i % instructions.length]
        node = node[left_or_right]
        i += 1
        if node.terminal?
          break if path.any? {|_, visited| node == visited }
          path << [i, node]
        end
      end
      path
    end

    p paths
    cycle_steps = paths.map {|path| path.last.first - 1 }
    p cycle_steps
    p cycle_steps.inject {|memo, x| memo.lcm(x) }
  end
end
