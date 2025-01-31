#!/usr/bin/env ruby

def abort_helpfully
    STDERR.puts "usage: #$0 DATASET PARTCODE"
    STDERR.puts "  DATASET can be test or real"
    STDERR.puts "  PARTCODE can be id or power"
    abort
end

data = case ARGV[0].to_s.downcase
when 'test'
    <<-END
        Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    END
when 'real'
    DATA.read
else
    abort_helpfully
end

partcode = case ARGV[1].to_s.downcase
when 'id'
    :id
when 'power'
    :power
else
    abort_helpfully
end

n = data.lines.map do |line|
    game_id = line[/Game (\d+):/, 1].to_i
    h = Hash.new { 0 }
    line.scan(/(\d+) (\w+)/).each do |n, col|
        h[col] = [h[col], n.to_i].max
    end
    p(h.merge(game_id:))
    if partcode == :id
        game_id if h['red'] <= 12 && h['green'] <= 13 && h['blue'] <= 14
    elsif partcode == :power
        h['red'] * h['green'] * h['blue']
    end
end.compact.sum
p n

__END__
Game 1: 2 red, 2 green; 6 red, 3 green; 2 red, 1 green, 2 blue; 1 red
Game 2: 2 green; 15 red, 5 blue; 2 green, 4 blue, 5 red; 3 green, 6 blue, 6 red; 6 blue, 1 green
Game 3: 10 blue, 8 red, 5 green; 5 green, 3 red; 12 red, 2 green, 9 blue; 6 green, 11 red
Game 4: 2 green, 3 blue, 1 red; 17 green, 1 blue, 1 red; 1 green, 5 red
Game 5: 4 green, 13 red, 3 blue; 14 blue, 5 green, 5 red; 2 blue, 7 green, 3 red; 5 green, 11 blue, 10 red
Game 6: 1 green, 4 red; 1 blue, 19 red, 5 green; 15 red, 1 green, 1 blue; 8 green, 12 red; 19 green, 7 red; 2 blue, 14 red, 12 green
Game 7: 1 blue, 3 red, 3 green; 4 green; 1 blue, 6 red, 5 green
Game 8: 1 green; 1 green, 16 red, 1 blue; 3 red, 1 green, 1 blue; 1 green; 2 blue; 9 red
Game 9: 5 green, 1 red; 6 red, 4 blue, 1 green; 9 green, 7 red, 6 blue; 11 red, 12 green, 4 blue
Game 10: 12 green, 4 blue, 7 red; 6 blue, 2 red; 7 green, 6 blue, 6 red
Game 11: 18 green, 2 red; 19 green, 14 red, 9 blue; 8 blue, 12 red, 5 green; 4 green, 12 red; 14 red, 7 green, 10 blue
Game 12: 8 red, 4 blue; 4 green, 1 red, 2 blue; 1 blue, 11 green, 12 red
Game 13: 5 green, 4 blue, 4 red; 4 red, 5 blue, 2 green; 1 red, 5 blue, 10 green
Game 14: 14 red, 1 green; 2 green, 3 blue, 7 red; 2 red, 4 blue; 3 green, 8 red, 4 blue; 2 green, 14 red, 4 blue; 3 green, 9 red, 6 blue
Game 15: 17 blue, 5 red, 1 green; 1 green, 2 red; 3 red, 2 green; 11 blue, 4 red, 2 green
Game 16: 5 red, 5 green, 1 blue; 5 blue, 15 red, 13 green; 3 blue, 6 red, 12 green; 1 green, 13 red, 9 blue; 15 blue, 13 green, 6 red; 5 green, 7 red, 3 blue
Game 17: 17 red, 9 blue; 19 red, 9 blue, 2 green; 18 red, 1 green, 8 blue; 10 blue, 2 red, 1 green; 7 red, 5 blue, 1 green; 2 green, 2 red, 5 blue
Game 18: 1 blue, 9 green, 1 red; 8 green, 5 blue; 4 blue, 9 green; 1 red, 6 green; 3 green, 3 blue, 1 red; 1 red, 1 blue, 4 green
Game 19: 3 blue, 3 red; 1 blue, 2 red, 4 green; 4 green, 2 red; 7 blue, 1 red
Game 20: 1 blue, 2 red, 6 green; 4 red, 10 green, 5 blue; 7 green, 1 blue; 3 green, 10 red, 1 blue; 3 blue, 11 red, 2 green; 10 green, 1 blue, 11 red
Game 21: 1 green, 17 blue, 8 red; 13 green, 8 blue, 7 red; 7 blue, 10 green, 2 red
Game 22: 4 green, 13 blue; 13 blue, 10 green; 8 green, 12 blue, 3 red; 6 green, 3 blue, 3 red
Game 23: 11 green, 7 red; 11 blue, 11 red; 12 green, 3 red; 7 red, 7 green, 15 blue; 10 green, 5 blue
Game 24: 1 blue, 15 green, 6 red; 2 red, 1 blue, 5 green; 13 green, 1 blue, 7 red; 1 blue; 19 green, 1 blue, 12 red; 13 green, 1 blue, 2 red
Game 25: 15 green, 1 blue, 2 red; 9 green, 5 blue; 16 green, 4 red; 3 blue, 2 red, 7 green
Game 26: 5 blue, 1 red; 9 blue, 1 green, 1 red; 1 red, 1 green, 4 blue
Game 27: 3 red, 4 blue, 2 green; 2 red, 3 blue; 1 blue, 1 red, 5 green
Game 28: 1 red, 3 green, 6 blue; 5 red, 2 blue, 3 green; 6 green, 4 red
Game 29: 8 green, 6 red, 18 blue; 18 blue, 2 green, 8 red; 2 red, 14 blue, 2 green; 2 red, 4 green, 19 blue; 11 green, 9 red, 8 blue
Game 30: 9 red, 11 blue, 6 green; 4 red, 6 green, 1 blue; 13 blue, 1 red, 1 green; 7 red, 1 green, 1 blue
Game 31: 11 red, 3 green; 3 green, 2 red; 6 red, 4 green; 4 blue, 9 red; 4 green, 2 red, 3 blue; 2 red, 1 blue, 6 green
Game 32: 4 red, 16 blue, 12 green; 10 blue, 7 green, 3 red; 7 blue, 4 green; 1 green, 8 blue, 3 red
Game 33: 6 green, 2 blue, 2 red; 1 red, 3 green, 7 blue; 9 blue, 1 green; 10 blue, 1 green, 1 red; 8 blue, 4 red, 6 green; 1 green, 2 red, 7 blue
Game 34: 4 blue, 6 red; 7 red, 5 green, 3 blue; 2 blue, 1 red; 5 blue, 2 green
Game 35: 8 green, 1 blue; 12 blue; 6 green, 13 blue; 9 blue, 4 green; 5 green, 1 red, 7 blue; 5 blue, 1 red, 6 green
Game 36: 10 red, 4 blue, 6 green; 15 blue, 1 green, 2 red; 16 red, 14 blue, 2 green
Game 37: 3 green, 1 red, 2 blue; 5 blue, 2 green, 4 red; 2 red, 3 green; 4 blue, 4 red, 1 green; 3 red, 4 blue, 3 green
Game 38: 9 red, 1 green, 16 blue; 1 green, 4 blue, 1 red; 10 blue, 1 red, 1 green; 3 red, 17 blue; 7 blue, 5 red
Game 39: 9 red, 16 blue, 3 green; 8 green, 3 red, 3 blue; 8 blue, 13 red, 1 green; 3 red, 17 blue, 3 green; 11 blue, 9 red, 3 green
Game 40: 4 blue, 2 green, 8 red; 3 blue; 7 blue
Game 41: 3 blue, 10 green, 7 red; 1 blue; 8 green, 4 blue, 1 red; 8 green, 7 red, 4 blue
Game 42: 6 green, 5 blue, 1 red; 5 blue, 2 red, 6 green; 1 green, 3 red, 3 blue; 1 red, 1 blue, 8 green; 2 red, 10 green; 4 red, 6 green
Game 43: 12 blue, 9 green, 9 red; 8 blue, 6 red, 2 green; 1 green, 8 blue, 12 red; 15 blue, 5 green, 13 red; 15 blue, 7 green, 8 red; 16 blue, 11 red, 8 green
Game 44: 4 green, 16 blue, 1 red; 5 green, 1 blue; 1 blue, 1 green; 11 blue, 1 red, 3 green; 10 blue, 1 red; 15 blue, 1 red, 3 green
Game 45: 12 blue, 6 green, 9 red; 5 red, 6 blue, 2 green; 4 blue, 5 green, 5 red; 2 green, 6 blue, 8 red; 9 red, 7 green, 7 blue
Game 46: 7 blue, 1 red; 1 green, 2 blue, 2 red; 3 red
Game 47: 10 blue, 11 green, 1 red; 10 green; 4 red, 6 blue, 16 green; 20 green, 2 blue; 1 green, 3 red, 6 blue; 4 red, 5 blue, 13 green
Game 48: 1 red, 4 blue, 3 green; 20 blue, 1 red, 8 green; 1 red, 12 green, 12 blue
Game 49: 5 green, 8 red, 2 blue; 2 blue, 2 red, 1 green; 3 red, 3 blue; 3 blue, 12 green
Game 50: 7 green, 8 red; 2 blue, 6 green; 1 green, 1 blue, 7 red
Game 51: 19 red, 13 blue, 4 green; 9 green, 10 red, 2 blue; 2 green, 20 red; 20 red, 2 green; 6 green, 10 blue, 5 red
Game 52: 1 red, 13 green; 11 green; 15 green; 1 red, 9 green, 1 blue
Game 53: 7 blue, 3 green; 1 red, 6 blue, 6 green; 7 blue, 1 red, 6 green
Game 54: 12 red, 1 green; 14 red, 10 green; 1 green, 7 red, 4 blue
Game 55: 1 blue, 5 green, 3 red; 3 green, 4 red; 6 red, 1 blue, 4 green
Game 56: 5 red, 1 blue, 2 green; 6 green; 4 red, 6 green; 6 green, 2 blue, 2 red; 4 red, 2 green, 2 blue; 4 red, 2 blue
Game 57: 6 green, 3 blue; 8 blue, 6 green, 5 red; 5 red, 2 green, 12 blue; 5 red, 7 green, 5 blue
Game 58: 2 blue, 1 red, 4 green; 1 red, 14 green; 2 green, 2 blue, 1 red
Game 59: 10 red, 11 blue, 6 green; 2 blue, 8 green; 1 green, 5 blue, 15 red; 3 red, 7 blue, 9 green; 9 green, 9 blue, 14 red; 8 green, 13 blue, 15 red
Game 60: 1 blue, 11 red, 7 green; 7 red, 3 blue; 16 red, 3 blue, 2 green; 2 red, 9 green, 2 blue; 2 blue, 8 red, 9 green; 15 red, 1 blue, 9 green
Game 61: 8 green, 15 blue; 16 blue, 1 green; 1 green, 11 blue; 1 green, 9 blue, 1 red; 8 green, 9 blue; 8 blue, 15 green
Game 62: 5 green, 4 blue; 1 blue, 2 green; 1 red, 16 green, 2 blue; 1 blue, 16 green, 1 red; 13 green, 2 blue
Game 63: 1 red, 1 blue; 1 green, 1 red; 1 green; 1 green, 2 red; 1 blue; 2 red
Game 64: 5 red, 1 blue, 5 green; 10 red, 4 green, 2 blue; 8 red, 1 blue
Game 65: 1 red, 8 green, 10 blue; 11 blue, 5 green, 1 red; 2 red, 5 blue, 1 green; 8 green, 7 blue
Game 66: 5 red, 1 green; 1 blue, 7 red; 4 red, 15 green, 1 blue; 8 red, 4 green; 1 blue, 15 green, 3 red
Game 67: 15 green, 7 blue, 1 red; 8 green, 7 blue; 5 blue, 1 red, 4 green; 2 green, 9 blue; 1 red, 6 blue
Game 68: 14 green, 17 red; 1 red, 2 blue, 17 green; 10 green; 3 red, 7 green, 2 blue
Game 69: 8 green, 12 red, 11 blue; 8 red, 2 blue, 10 green; 2 green, 6 blue, 2 red; 10 red, 12 green, 3 blue
Game 70: 2 blue, 8 green; 9 green; 2 red; 2 red, 5 green; 3 green, 2 blue, 3 red; 4 red, 1 blue
Game 71: 3 green, 4 blue; 13 red, 13 blue; 4 green, 3 red, 1 blue; 1 green, 7 blue, 3 red; 3 green, 9 blue, 13 red; 10 red, 12 blue, 5 green
Game 72: 4 green, 17 red, 4 blue; 4 green, 2 blue; 1 red, 10 blue, 1 green; 3 green; 2 blue, 15 red, 3 green; 6 red, 10 blue
Game 73: 14 green, 9 red, 6 blue; 10 red, 4 green, 7 blue; 9 green, 5 red, 6 blue; 6 red, 2 blue; 5 blue, 7 red, 14 green; 4 green, 6 blue, 5 red
Game 74: 19 blue, 7 green, 1 red; 12 blue, 11 green, 1 red; 2 red, 5 blue, 14 green; 5 green, 5 blue, 7 red
Game 75: 12 green, 5 blue, 12 red; 17 green, 10 red, 7 blue; 1 blue, 8 red, 1 green; 11 red, 10 green, 4 blue; 1 blue, 10 green; 1 green, 5 blue, 7 red
Game 76: 9 green, 2 red, 3 blue; 6 red, 13 green, 5 blue; 14 green, 9 red, 2 blue; 1 blue, 6 red, 2 green; 8 red, 10 green, 1 blue; 2 red, 15 green, 7 blue
Game 77: 5 blue, 2 green, 1 red; 4 blue, 14 red; 3 blue, 1 green, 8 red; 13 red, 8 blue; 17 blue, 2 green, 9 red; 11 blue, 1 green
Game 78: 5 blue, 4 green, 4 red; 1 red, 9 green, 4 blue; 8 green
Game 79: 5 blue, 6 red; 2 blue, 1 green, 9 red; 3 green; 8 red, 1 green, 5 blue; 2 green, 5 red
Game 80: 1 green, 2 blue, 8 red; 9 green, 12 red; 17 green, 8 red, 11 blue
Game 81: 8 red, 11 green, 13 blue; 9 red, 14 blue, 14 green; 14 blue, 11 green, 1 red; 5 red, 13 green, 3 blue; 4 green, 9 red, 2 blue; 11 red, 5 blue, 2 green
Game 82: 13 green, 2 red, 1 blue; 10 green, 2 blue; 2 blue, 11 green; 4 red, 1 green, 3 blue; 14 green, 1 blue, 2 red
Game 83: 6 blue, 2 red; 3 blue, 11 red, 1 green; 12 red, 1 green, 1 blue; 2 red; 10 red, 6 blue
Game 84: 1 green, 13 blue, 2 red; 4 red, 17 blue, 18 green; 17 green, 13 blue, 4 red; 4 blue, 15 green, 3 red; 3 red; 15 blue, 1 red, 12 green
Game 85: 11 green, 7 red; 7 green, 4 blue, 6 red; 8 red, 7 blue, 2 green; 11 green, 10 red, 3 blue
Game 86: 10 green, 5 blue; 4 blue, 7 red, 16 green; 8 red, 1 blue, 12 green
Game 87: 7 red, 3 green; 1 blue, 5 red, 14 green; 13 red, 4 green; 19 green, 9 red; 12 green, 1 red
Game 88: 5 red, 16 blue; 2 green, 14 blue, 1 red; 14 blue, 1 green
Game 89: 1 green, 2 blue, 1 red; 10 blue; 4 blue; 2 green, 14 blue; 14 blue, 1 red, 2 green
Game 90: 1 blue, 13 green, 1 red; 4 blue, 1 red, 17 green; 9 green, 7 blue, 5 red; 1 blue, 3 red, 15 green; 3 red, 4 blue, 15 green
Game 91: 1 green; 9 green, 2 red, 2 blue; 3 blue, 12 green, 1 red; 2 red, 1 blue, 6 green
Game 92: 1 green, 4 blue, 10 red; 12 blue, 9 red, 3 green; 10 blue, 8 red, 2 green
Game 93: 7 blue, 5 red; 2 green, 1 blue, 6 red; 1 blue, 6 red
Game 94: 8 red, 3 green, 8 blue; 3 red, 1 green, 4 blue; 4 green, 17 blue, 2 red; 2 green, 9 red, 7 blue; 13 red, 4 green, 18 blue
Game 95: 9 blue, 11 green; 14 green, 10 blue, 11 red; 13 blue, 10 green, 1 red; 6 red, 4 green, 1 blue; 9 blue, 13 green
Game 96: 3 red, 3 green; 16 green, 2 blue; 7 blue, 3 red, 16 green; 10 green, 1 red
Game 97: 4 red, 6 blue; 2 red; 13 red, 6 blue, 3 green; 1 green, 12 red; 3 green, 2 blue, 16 red
Game 98: 1 red, 6 green, 7 blue; 14 red, 3 green, 2 blue; 16 blue, 14 red, 11 green; 5 blue; 9 red, 1 green, 15 blue
Game 99: 3 blue, 8 green, 1 red; 4 green, 1 blue, 2 red; 1 red, 4 green; 2 blue, 4 green
Game 100: 8 red, 2 blue, 1 green; 2 blue, 4 red, 2 green; 9 red, 1 green; 2 green, 2 red; 3 red, 5 blue; 5 blue, 8 red