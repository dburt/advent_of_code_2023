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
      # puts line
      case line
      when /^seeds:([ \d]+)/
        # puts 'seeds'
        @seeds = $1.split.map(&:to_i)
        if seeds_are == :individuals
          nil
        elsif seeds_are == :ranges
          @seeds = RangeSet.from_starts_and_lengths(@seeds)
          puts "#{@seeds.count} ranges of #{@seeds.size} seeds!"
        end
      when /^(\w+)-to-(\w+) map:/
        # puts 'map'
        @maps << Map.new($1, $2)
      when /^([\d ]+)/
        triplet = $1.split.map(&:to_i)
        @maps.last.add(*triplet)
        puts "map numbers in #{@maps.last.name}: #{triplet} -> #{@maps.last}"
      end
    end
  end
  def map_seed_to_location(seed)
    puts "mapping seed #{seed}"
    maps.inject(seed) do |memo, map|
      mapped = map[memo]
      puts "applied #{map.name} and got #{mapped}"
      mapped
    end
  end
  def locations
    @locations ||= begin
      locations = seeds.map {|seed| map_seed_to_location(seed) }
      locations = locations.inject(&:+) if locations.first.kind_of?(RangeSet)
      locations
    end
  end
  def inspect
    "Almanac(seeds=#{seeds.inspect} maps=#{maps.inspect})"
  end

  class Map < Struct.new(:source, :destination, :mapped_ranges)
    def initialize(source, destination, mapped_ranges = {})
      super
    end
    def name
      "#{source}-to-#{destination} map"
    end
    def add(dest_range_start, src_range_start, range_length)
      range = src_range_start...(src_range_start + range_length)
      offset = dest_range_start - src_range_start
      mapped_ranges[range] = offset
    end
    def [](src)
      src = RangeSet(src) if src.kind_of?(Range)
      case src
      when Integer
        mapped_range = mapped_ranges.detect do |range, offset|
          range.include?(src)
        end
        offset = mapped_range&.last || 0
        src + offset
      when RangeSet
        intersections = mapped_ranges.map do |range, offset|
          # p [range, src]
          src.intersection(range)
        end
        # p intersections
        mapped_intersections = mapped_ranges.zip(intersections).map do |(range, offset), intersection|
          # p [[range, offset], intersection]
          intersection + offset # unless intersection.empty?
        end.inject(&:+)
        # p [src, mapped_intersections]
        unmapped = src - intersections.inject(&:+)
        # p [src, mapped_intersections, unmapped]
        mapped_intersections + unmapped
      else
        raise ArgumentError, "expecting Integer or RangeSet argument but got #{src.class}"
      end
    end
  end
end

class Range
  def intersection(other)
    min = [self.min, other.min].max
    max = [self.max, other.max].min
    (min..max) if min <= max
  end
  def minus_ranges(ranges)
    RangeSet(self) - RangeSet(*ranges)
  end
end

class RangeSet
  include Enumerable
  def initialize(ranges)
    @_ = ranges.sort_by(&:begin)
  end
  def self.from_starts_and_lengths(starts_and_lengths)
    p starts_and_lengths
    new(starts_and_lengths.each_slice(2).
        map {|start, length| (start...(start + length)) })
  end
  def each(&block)
    @_.each(&block)
  end
  def size
    sum(&:size)
  end
  def min
    map(&:min).compact.min
  end
  def empty?
    size == 0
  end
  def distinct?
    return @distinct unless @distinct.nil?
    @distinct = true
    @_.inject do |a, b|
      unless a.max < b.min
        @distinct = false
        break
      end
      b
    end
    @distinct
  end
  def +(other)
    case other
    when RangeSet
      RangeSet(*@_, *other.to_a)
    when Integer
      RangeSet(*map {|range| (range.min + other)..(range.max + other) })
    else
      raise ArgumentError, "expecting RangeSet or Integer argument but got #{src.class}"
    end
  end
  def intersection(other_range)
    int = map do |range|
      range.intersection(other_range)
    end.compact
    RangeSet(*int)
  end
  def -(other)
    # puts "#{self} - #{other}"
    difference = @_.dup
    other.each do |minus_range|
      difference.map! do |range|
        next unless range
        if minus_range.max < range.min || range.max < minus_range.min
          range
        elsif range.min < minus_range.min && minus_range.max < range.max
          [range.min..(minus_range.min - 1), (minus_range.max + 1)..range.max]
        elsif range.min < minus_range.min
          range.min..(minus_range.min - 1)
        elsif minus_range.max < range.max
          (minus_range.max + 1)..range.max
        else
          nil
        end
      end
      difference.flatten!
    end
    difference.compact!
    RangeSet(*difference)
  end
  def to_s
    "RangeSet(#@_)"
  end
end
def RangeSet(*ranges)
  RangeSet.new(ranges)
end

if __FILE__ == $0
  if ARGV == ['test']
    rs = RangeSet(100..200, 1..2, 3..4, 5..6, 7...9, 9..10)
    p rs.distinct?
    p(rs - rs)
    p(rs - RangeSet(2..5, 101..102))
    p(rs - RangeSet(2..5, 8..8, 101..102))
    p [rs.count, rs.size]
    p RangeSet(1..3, 7..9) + RangeSet(100..101, 79..80)
    p RangeSet(1..3, 7..9) + 3
    p RangeSet().empty?
    p RangeSet(100..101, 79..80).min
    exit
  end

  config = AocConfig.new(test_data:)
  seeds_are = [nil, :individuals, :ranges][config.part]
  almanac = Almanac.new(config.data, seeds_are:)
  puts "almanac compiled!"
  p almanac
  puts "#{almanac.locations.size} locations in #{almanac.locations.count} groups"
  p almanac.locations
  p almanac.locations.min
end
