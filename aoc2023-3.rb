#!/usr/bin/env ruby

test_data = <<-END
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
END

module AocHelper
    class << self
        def parse_args(test_data:)
            @dataset = ARGV[0].to_s.downcase
            abort_helpfully unless ['test', 'real'].include?(@dataset)
            @part = ARGV[1].to_i
            abort_helpfully unless [1, 2].include?(@part)
            @data = if @dataset == 'test'
                test_data
            else
                File.read(__FILE__.sub(/\.rb$/, '.data'))
            end
        end
        def dataset
            @dataset
        end
        def part
            @part
        end
        def data
            @data
        end
        def abort_helpfully
            STDERR.puts "usage: #$0 DATASET PARTCODE"
            STDERR.puts "  DATASET can be test or real"
            STDERR.puts "  PARTCODE can be 1 or 2"
            abort
        end
    end
end

class EngineSchematic
    attr_reader :numbers
    attr_reader :symbols
    def initialize(str)
        @numbers = []
        @symbols = []
        str.lines.each_with_index do |line, y|
            x0 = 0
            line.scan(/((\d+)|(\.+)|(.))/).each do |m|
                # p [m[0], m[1], m[2], m[3]]
                x1 = x0 + m[0].length
                numbers << {number: m[1], y: y, x: (x0...x1)} if m[1]
                symbols << {symbol: m[3], y: y, x: (x0...x1)} if m[3]
                # '.' just count characters to keep track of x
                x0 = x1
            end
        end
    end
    def part_numbers
        numbers.select do |number|
            symbols.any? do |symbol|
                x_range = (symbol[:x].begin.pred)...(symbol[:x].end.succ)
                y_range = (symbol[:y].pred)..(symbol[:y].succ)
                ok = y_range.cover?(number[:y]) &&
                    (x_range.cover?(number[:x].begin) ||
                    x_range.cover?(number[:x].end))
                if ok && number[:number] == '13'
                    p [number, symbol, x_range, y_range]
                end
            end
        end.map do |number|
            number[:number].to_i
        end
    end
end

if __FILE__ == $0
    AocHelper.parse_args(test_data:)
    schematic = EngineSchematic.new(AocHelper.data)
    # pp schematic
    p schematic.part_numbers
    p schematic.part_numbers.sum
end
