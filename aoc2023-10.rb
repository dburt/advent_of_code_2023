#!/usr/bin/env ruby

require_relative 'aoc2023-3'  # provides AocConfig

test_data = <<-END
7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ
END

class Tile < Struct.new(:shape, :directions, :connected_tiles)
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
          @start_tile = tile if char == 'S'
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
    @rows.each do |row|
      row.each do |tile|
        yield tile
      end
    end
  end
  def each_with_x_y
    @rows.each_with_index do |row, y|
      row.each_with_index do |tile, x|
        yield tile, [x, y]
      end
    end
  end
  def [](x_y)
    x, y = x_y
    @rows[y][x]
  end
  def connect_tiles
    each_with_x_y do |tile, (x, y)|
      tile.directions.each do |direction|
        dx, dy = Tile::DIRECTION_OFFSETS[direction]
        other_tile = @rows[y + dy][x + dx]
        if other_tile&.has_direction_opposite?(direction)
          tile.connected_tiles << other_tile
        end
      end
    end
  end
  def trace_circuit
    @circuit = [start_tile]
    loop do
      next_tile = (@circuit[-1].connected_tiles - [@circuit[-2]]).first
      break if next_tile == start_tile
      @circuit << next_tile
    end
  end
end

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  if config.part == 1
    grid = Grid.new(config.data)
    puts grid
    p grid[[0, 2]]
    p grid[[1, 2]]
    p grid.start_tile
    p grid.circuit
    p grid.circuit.length
    p grid.circuit.length / 2
  elsif config.part == 2
    raise NotImplementedError
  end
end
