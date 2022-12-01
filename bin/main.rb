#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/match_functions.rb'

inputFile = ARGV
parser = MatchFunctions::Parser.new
league = MatchFunctions::League.new
all_teams_entered = false

puts 'Welcome to the Matchday Companion for the Jane Technologies Soccer League!'
puts 'To leave the program at any point in execution, type `exit`.'

case inputFile.length
when 1
  # todo: need to make sure file exists / is the right type before we do this
  IO.foreach(inputFile[0]) do |line|
    all_teams_entered = parser.parse_line(line, league, all_teams_entered)
  end
when 0
  queue = []
  Thread.new do
    loop do
      input = gets.chomp
      exit if input == 'exit'

      queue << input
    end
  end

  loop do
    unless queue.empty?
      next_line = queue.shift
      parser.parse_line(next_line, league)
    end
  end
end
# todo - need to handle the case where there are extra args
