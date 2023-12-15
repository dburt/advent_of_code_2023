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

def expand(image)
  expanded = []
  image.lines.each do |line|
    line.chomp!
    expanded << line.chars
    expanded << line.chars unless line =~ /#/
  end
  expanded = expanded.transpose
  (expanded.length - 1).downto(0) do |i|
    expanded[i + 1, 0] = [expanded[i]] unless expanded[i].join =~ /#/
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
  if config.part == 1
    image = expand(config.data)
    puts image
    coords = galaxy_coords(image)
    p coords
    distances = each_pair_from(coords).map do |(xa, ya), (xb, yb)|
      (xb - xa).abs + (yb - ya).abs
    end
    p distances
    p distances.sum
  elsif config.part == 2
    raise NotImplementedError
  end
end
