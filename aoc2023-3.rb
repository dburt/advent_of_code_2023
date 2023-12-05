#!/usr/bin/env ruby

require 'paint'

test_data = <<-END
467..114..
...*......
..35..633.
..@...#...
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
    def adjacent?(component1, component2)
        component1.y.between?(component2.y - 1, component2.y + 1) && 
            (component1.x.begin <= component2.x.begin + 1 && component1.x.end >= component2.x.end - 1)
    end
    def part_number?(component)
        component.type == :number &&
            symbols.any? {|symbol| adjacent?(component, symbol) }
    end
    def gear?(component)
        component.mark == '*' &&
            numbers.count {|number| adjacent?(number, component) } == 2
    end
    def gears
        symbols.select {|symbol| gear?(symbol) }
    end
    def gear_ratios
        gears.map do |gear|
            numbers.select {|number| adjacent?(number, gear) }.map {|number| number.mark.to_i }.inject(:*)
        end
    end
    def inspect
        prev_y = 0
        all_components.map do |component|
            s = component.mark
            s = "\n" + s unless component.y == prev_y
            effects = case component.type
            when :symbol
                gear?(component) ? [:yellow] : [:blue]
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
    if config.part == 1
        p schematic.part_numbers
        p schematic.part_numbers.sum
    elsif config.part == 2
        p schematic.gear_ratios
        p schematic.gear_ratios.sum
    end
end
