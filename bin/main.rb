#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/matchday_companion'

input = ARGV
input_file = input[0]

matchday = {}
standings = {}
stashed_values = nil
teams = nil
matchday_number = 1
ACCEPTED_FORMATS = ['.txt'].freeze

parser = MatchdayCompanion::Parser.new

Team = Struct.new(:name, :score)

puts 'Welcome to the Matchday Companion for the Jane Technologies Soccer League!'
puts 'To leave the program at any point in execution, type `exit`.'
puts ''

case input.length
when 1
  unless ACCEPTED_FORMATS.include?(File.extname(input_file))
    puts "Invalid file type! The following types are accepted: #{ACCEPTED_FORMATS.join(', ')}"
    exit
  end

  unless File.file?(input_file)
    puts "Oop, that file doesn't exist! Please check your file path and run again."
    exit
  end

  File.foreach(input_file) do |line|
    next unless parser.valid_line_format?(line) # deal with invalid lines

    team_one, team_two = parser.define_teams(line)
    teams = [team_one, team_two]

    if matchday.key?(team_one.name) || matchday.key?(team_two.name)
      stashed_values = teams

      parser.increment_score_and_print_matchday(matchday, matchday_number, standings)
      matchday = {}
      stashed_values.each { |team| matchday[team.name] = { name: team.name, score: team.score } }

      stashed_values = nil
      matchday_number += 1
    else
      teams.each do |team|
        matchday[team.name] = { name: team.name, score: team.score }
      end
    end
  end

  parser.increment_score_and_print_matchday(matchday, matchday_number, standings) # final matchday
when 0
  queue = []
  Thread.new do
    loop do
      input = $stdin.gets
      queue << input
    end
  end

  loop do
    next if queue.empty?

    next_line = queue.shift

    if next_line.nil? || next_line.chomp == 'exit'
      parser.increment_score_and_print_matchday(matchday, matchday_number, standings) # final matchday
      exit
    end

    next unless parser.valid_line_format?(next_line) # deal with invalid lines

    team_one, team_two = define_teams(next_line.chomp)
    teams = [team_one, team_two]

    if matchday.key?(team_one.name) || matchday.key?(team_two.name)
      stashed_values = teams

      parser.increment_score_and_print_matchday(matchday, matchday_number, standings)
      matchday = {}
      stashed_values.each { |team| matchday[team.name] = { name: team.name, score: team.score } }

      stashed_values = nil
      matchday_number += 1
    else
      teams.each do |team|
        matchday[team.name] = { name: team.name, score: team.score }
      end
    end
  end
else
  puts 'Too many arguments!'
  puts 'Usage:'
  puts 'bin/main.rb <FILENAME>    : read in from a file'
  puts 'cat <FILE> | bin/main.rb  : pipe in from stdin'
  puts 'bin/main.rb               : feed each line in one-by-one in the CLI.'
end
