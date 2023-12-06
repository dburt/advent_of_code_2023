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
  def initialize(data, seeds_are:)
    @maps = []
    data.lines.each do |line|
      puts line
      case line
      when /^seeds:([ \d]+)/
        puts 'seeds'
        @seeds = $1.split.map(&:to_i)
        if seeds_are == :individuals
          nil
        elsif seeds_are == :ranges
          @seeds = @seeds.group_by.with_index {|n, i| i / 2 }.
            map {|_, (start, length)| (start...(start + length)) }
          n = @seeds.sum {|range| range.size }
          puts "#{n} seeds!"
          abort if n > 1_000_000
          @seeds = @seeds.map(&:to_a).flatten
        end
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
  def map_seed_to_location(seed)
    puts "mapping seed #{seed}..."
    maps.inject(seed) do |memo, map|
      map[memo]
    end
  end
  def locations
    seeds.map {|seed| map_seed_to_location(seed) }
  end

  class Map < Struct.new(:source, :destination, :mapped_ranges)
    def initialize(source, destination, mapped_ranges = {})
      super
    end
    def add(dest_range_start, src_range_start, range_length)
      range = src_range_start...(src_range_start + range_length)
      offset = dest_range_start - src_range_start
      mapped_ranges[range] = offset
    end
    def [](src)
      mapped_range = mapped_ranges.detect do |range, offset|
        range.include?(src)
      end
      offset = mapped_range&.last || 0
      src + offset
    end
  end
end

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  seeds_are = [nil, :individuals, :ranges][config.part]
  almanac = Almanac.new(config.data, seeds_are:)
  # pp almanac
  p almanac.locations unless [config.part, config.dataset] == [2, 'real']
  p almanac.locations.min
  # binding.pry
  if config.part == 1
  elsif config.part == 2
  end
end
