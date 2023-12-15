#!/usr/bin/env ruby

require_relative 'aoc2023-3'  # provides AocConfig
require 'set'

test_data0 = <<-END
7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ
END

test_data1 = <<-END
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
END

test_data = <<-END
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
END

class Tile < Struct.new(:shape, :directions, :connected_tiles, :category)
  SHAPE_DIRECTIONS = {
    '|': [:N, :S],  # is a vertical pipe connecting north and south.
    '-': [:E, :W],  # is a horizontal pipe connecting east and west.
    'L': [:N, :E],  # is a 90-degree bend connecting north and east.
    'J': [:N, :W],  # is a 90-degree bend connecting north and west.
    '7': [:S, :W],  # is a 90-degree bend connecting south and west.
    'F': [:S, :E],  # is a 90-degree bend connecting south and east.
    '.': [      ],  # is ground; there is no pipe in this tile.
    'S': [:N, :E, :S, :W],  # is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
  }
  OPPOSITE_DIRECTIONS = {
    N: :S,
    S: :N,
    E: :W,
    W: :E,
  }
  DIRECTION_OFFSETS = {
    N: [0, -1],
    E: [+1, 0],
    S: [0, +1],
    W: [-1, 0],
  }
  def initialize(char)
    shape = char.to_sym
    directions = SHAPE_DIRECTIONS[shape]
    super shape, directions, []
  end
  def has_direction_opposite?(direction)
    directions.include?(OPPOSITE_DIRECTIONS[direction])
  end
  def to_s
    shape.to_s
  end
  def inspect
    "(Tile #{shape} #{directions} #{connected_tiles.map(&:to_s)})"
  end
end

class Grid
  include Enumerable
  attr_accessor :rows, :start_tile, :circuit
  def initialize(data)
    @rows = data.lines.map do |line|
      line.chomp.chars.map do |char|
        Tile.new(char).tap do |tile|
          if char == 'S'
            @start_tile = tile
            tile.category = :circuit
          end
        end
      end
    end
    connect_tiles
    trace_circuit
  end
  def to_s
    @rows.map {|row| row.map {|tile| tile.to_s }.join + "\n" }.join
  end
  def each
    return enum_for(:each) unless block_given?
    @rows.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        yield tile, [x, y]
      end
    end
  end
  def [](x_y)
    x, y = x_y
    @rows[y][x] if @rows[y]
  end
  def connect_tiles
    each do |tile, (x, y)|
      tile.directions.each do |direction|
        dx, dy = Tile::DIRECTION_OFFSETS[direction]
        other_tile = self[[x + dx, y + dy]]
        if other_tile&.has_direction_opposite?(direction)
          tile.connected_tiles << other_tile
        end
      end
    end
  end
  def trace_circuit
    @circuit = [start_tile]
    loop do
      next_tile = (@circuit[-1].connected_tiles - [@circuit[-2]]).first rescue binding.pry
      break if next_tile == start_tile
      next_tile.category = :circuit
      @circuit << next_tile
    end
  end
  def categorise_tiles
    @flood_fill_grid ||= FloodFillGrid.new(self)
    each do |tile, (x, y)|
      if tile.category == :circuit
        nil
      elsif @flood_fill_grid.filled?(x, y)
        tile.category = :outside
      else
        tile.category = :inside
      end
    end
  end
  def count_inside
    count do |tile, (x, y)|
      tile.category == :inside
    end
  end
end
class FloodFillGrid
  attr_reader :rows, :start_tile, :width, :height
  EMPTY = '.'
  FILLED = 'O'
  CORNER_OFFSETS = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
  def initialize(grid)
    @height = grid.rows.count * 3 + 2
    @width = grid.rows.first.count * 3 + 2
    @rows = height.times.map { [EMPTY] * width }
    grid.each do |tile, (x, y)|
      @rows[y * 3 + 2][x * 3 + 2] = tile
      @start_tile = tile if tile.shape == :S
      tile.directions.each do |direction|
        dx, dy = Tile::DIRECTION_OFFSETS[direction]
        @rows[y * 3 + 2 + dy][x * 3 + 2 + dx] = 'X'
      end
    end
    flood_fill
  end
  def [](x_y)
    x, y = x_y
    rows[y][x] if rows[y]
  end
  def filled?(x, y)
    CORNER_OFFSETS.any? do |dx, dy|
      self[[3 * x + dx + 2, 3 * y + dy + 2]] == FILLED
    end
  end
  def to_s
    rows.map {|row| row.to_a.join + "\n" }.join
  end
  def flood_fill
    edges = [[0, 0]]
    until edges.empty? do
      edges.each do |x, y|
        rows[y][x] = FILLED
      end
      neighbours = Set.new
      edges.each do |x, y|
        Tile::DIRECTION_OFFSETS.values.each do |dx, dy|
          neighbours << [x + dx, y + dy]
        end
      end
      edges = neighbours.select do |x, y|
        self[[x, y]] == EMPTY
      end
    end
  end
end

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  grid = Grid.new(config.data)
  puts grid
  if config.part == 1
    # p grid[[0, 2]]
    # p grid[[1, 2]]
    # p grid.start_tile
    # p grid.circuit
    # p grid.circuit.length
    p grid.circuit.length / 2
  elsif config.part == 2
    # bigger_grid = FloodFillGrid.new(grid)
    # puts bigger_grid
    grid.categorise_tiles
    grid.rows.each do |row|
      puts row.map {|tile| tile.category.to_s[0] }.join
    end
    p grid.count_inside
  end
end
