#!/usr/bin/env ruby

require_relative 'aoc2023-3'  # provides AocConfig

test_data = <<-END
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
END

def expand(image, by: 2)
  expanded = []
  image.lines.each do |line|
    line.chomp!
    expanded << line.chars
    next if line =~ /#/
    (by - 1).times do
      expanded << line.chars
    end
  end
  expanded = expanded.transpose
  (expanded.length - 1).downto(0) do |i|
    next if expanded[i].any? {|char| char == '#' }
    (by - 1).times do
      expanded[i + 1, 0] = [expanded[i]]
    end
  end
  expanded = expanded.transpose.map {|row| row.join + "\n" }.join
end

def galaxy_coords(image)
  coords = []
  image.lines.each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      coords << [x, y] if char == '#'
    end
  end
  coords
end

def each_pair_from(list)
  return enum_for(:each_pair_from, list) unless block_given?
  list.each_with_index do |item, i|
    (i + 1).upto(list.length - 1) do |j|
      yield item, list[j]
    end
  end
end

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  image = expand(config.data)
  puts image
  coords = galaxy_coords(image)
  distances = each_pair_from(coords).map do |(xa, ya), (xb, yb)|
    (xb - xa).abs + (yb - ya).abs
  end
  total = distances.sum
  if config.part == 1
    puts image
    p coords
    p distances
    p total
  elsif config.part == 2
    image3 = expand(config.data, by: 3)
    puts image3
    coords3 = galaxy_coords(image3)
    distances3 = each_pair_from(coords3).map do |(xa, ya), (xb, yb)|
      (xb - xa).abs + (yb - ya).abs
    end
    total3 = distances3.sum
    p [total, total3, total3 - total]
    expansion_increment = total3 - total
    p total + (expansion_increment * (10 - 2))
    p total + (expansion_increment * (100 - 2))
    p total + (expansion_increment * (1_000_000 - 2))
    # 82000210 is too low
    
  end
end
