#!/usr/bin/env ruby

require 'paint'

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

class AocConfig
    attr_reader :dataset, :part, :data
    def initialize(test_data:)
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
    def abort_helpfully
        STDERR.puts "usage: #$0 DATASET PARTCODE"
        STDERR.puts "  DATASET can be test or real"
        STDERR.puts "  PARTCODE can be 1 or 2"
        abort
    end
end

class EngineComponent < Struct.new(:mark, :x, :y, :type)
end

class EngineSchematic
    attr_reader :numbers, :symbols, :all_components
    def initialize(str)
        @numbers = []
        @symbols = []
        @all_components = []
        str.lines.each_with_index do |line, y|
            x0 = 0
            line.scan(/((\d+)|(\.+)|(.))/).each do |m|
                # p [m[0], m[1], m[2], m[3]]
                x1 = x0 + m[0].length
                t = m[1] && :number || m[2] && :space || m[3] && :symbol
                component = EngineComponent.new(m[0], (x0..(x1 - 1)), y, t)
                numbers << component if m[1]
                symbols << component if m[3]
                all_components << component
                x0 = x1
            end
        end
    end
    def part_numbers
        numbers.select do |number|
            part_number?(number)
        end.map do |number|
            number.mark.to_i
        end
    end
    def part_number?(component)
        component.type == :number &&
            symbols.any? do |symbol|
                component.y.between?(symbol.y - 1, symbol.y + 1) && 
                    (component.x.begin <= symbol.x.begin + 1 && component.x.end >= symbol.x.end - 1)
            end
    end
    def inspect
        prev_y = 0
        all_components.map do |component|
            s = component.mark
            s = "\n" + s unless component.y == prev_y
            effects = case component.type
            when :symbol
                [:yellow]
            when :number
                part_number?(component) ? [:green] : [:red]
            else []
            end
            prev_y = component.y
            Paint[s, *effects]
        end.join
    end
end

if __FILE__ == $0
    config = AocConfig.new(test_data:)
    schematic = EngineSchematic.new(config.data)
    pp schematic
    # schematic.pretty_print
    p schematic.part_numbers
    p schematic.part_numbers.sum
end
