#!/usr/bin/env ruby

require_relative 'aoc2023-3'  # provides AocConfig

test_data = <<-END
END

if __FILE__ == $0
  config = AocConfig.new(test_data:)
  if config.part == 1
  elsif config.part == 2
    raise NotImplementedError
  end
end
