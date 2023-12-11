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
    "(Node #{name} left=#{left.name} right=#{right.name})"
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
  p [instructions, network]
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
    node_keys = network.keys.grep(/A$/)
    nodes = node_keys.map {|key| linked_list[key] }
    p nodes
    # exit
    i = 0
    # resume:
    # [28455000000, 1, [:XKT, :NGF, :DPV, :QXK, :XDM, :XLX]]
    # [28513000000, 0, [:GMJ, :JPS, :MCB, :QMS, :CTM, :LHN]]
    # [66239000000, 1, [(Node QMH left=NKG right=SDJ), (Node CND left=VKB right=PGQ), (Node TXH left=HNK right=VHQ), (Node QLS left=QBB right=NCG), (Node GQM left=QCG right=GGC), (Node NCT left=SXG right=CLF)]]
    # 810m17.179s real time, 496m32.236s user time
    # i, nodes = [28513000000, [:GMJ, :JPS, :MCB, :QMS, :CTM, :LHN].map {|key| linked_list[key] }]
    # [66239000000, [:QMH, :CND, CND, :TXH, :QLS, :GQM]]
    # real    946m56.389s
    i, nodes = [66239000000, [:QMH, :CND, CND, :TXH, :QLS, :GQM]]
    until nodes.all? {|node| node.terminal? }
      left_or_right = instructions[i % instructions.length]
      # nodes.map! {|node| network[node][left_or_right] }
      nodes.map! {|node| node[left_or_right] }
      i += 1
      p [i, left_or_right, nodes] if i % 1_000_000 == 0
      # [28455000000, 1, [:XKT, :NGF, :DPV, :QXK, :XDM, :XLX]]
    end
    p i
  end
end
