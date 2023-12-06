#!/usr/bin/env ruby

require 'pry'
require_relative 'aoc2023-3'  # provides AocConfig

test_data = <<-END
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
END

class Almanac
  attr_reader :seeds, :maps
  def initialize(data)
    @maps = []
    data.lines.each do |line|
      puts line
      case line
      when /^seeds:([ \d]+)/
        puts 'seeds'
        @seeds = $1.split.map(&:to_i)
      when /^(\w+)-to-(\w+) map:/
        puts 'map'
        @maps << Map.new($2, $1)
      when /^([\d ]+)/
        puts 'map numbers'
        p ($1.split.map(&:to_i))
        @maps.last.add(*($1.split.map(&:to_i)))
      end
    end
  end

  class Map < Struct.new(:source, :destination)
    attr_reader :hash
    def initialize(source, destination)
      super
      @hash = Hash.new {|h, k| k }
    end
    def add(dest_range_start, src_range_start, range_length)
      range_length.times do |i|
        @hash[src_range_start + i] = dest_range_start + i
      end
    end
    def [](src)
      hash[src]
    end
  end
end

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  almanac = Almanac.new(config.data)
  pp almanac
  # binding.pry
  if config.part == 1
  elsif config.part == 2
  end
end
