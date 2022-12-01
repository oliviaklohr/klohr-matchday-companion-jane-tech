#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'
require_relative '../lib/match_functions'

input = ARGV
input_file = input[0]

matchday = {}
standings = {}
stashed_values = nil
teams = nil
matchday_number = 1

Team = Struct.new(:name, :score)

puts 'Welcome to the Matchday Companion for the Jane Technologies Soccer League!'
puts 'To leave the program at any point in execution, type `exit`.'
puts ''

def separate_team_name_and_score(team)
  team_data = team.split(' ')
  score = team_data.pop.to_i
  name = team_data.join(' ')

  [name, score]
end

def score_match(team_one, team_two)
  if team_one[:score] > team_two[:score]
    3
  else
    team_one[:score] == team_two[:score] ? 1 : 0
  end
end

def print_matchday(matchday_number, sorted_standings)
  puts "Matchday #{matchday_number}"
  sorted_standings.each_with_index do |record, idx|
    puts "#{record[0]}: #{record[1][:score]}" if idx <= 2
  end
  puts ''
end

def increment_score(standings, first_team, second_team)
  if standings.key?(first_team[:name])
    current_score = standings[first_team[:name]][:score]
    standings[first_team[:name]] = { score: current_score + score_match(first_team, second_team) }
  else
    standings[first_team[:name]] = { score: score_match(first_team, second_team) }
  end
end

def sort_standings(standings)
  standings.sort_by { |k,v| [-v[:score], k] }
end

def define_teams(line)
  one, two = line.split(', ')
  team_one_name, team_one_score = separate_team_name_and_score(one)
  team_two_name, team_two_score = separate_team_name_and_score(two)

  team_one = Team.new(team_one_name, team_one_score)
  team_two = Team.new(team_two_name, team_two_score)

  [team_one, team_two]
end

case input.length
when 1
  # todo: need to make sure file exists / is the right type before we do this
  IO.foreach(input_file) do |line|
    team_one, team_two = define_teams(line)
    teams = [team_one, team_two]

    if matchday.key?(team_one.name) || matchday.key?(team_two.name)
      stashed_values = teams
      num_games = matchday.length / 2
      index = 0

      num_games.times do
        first_team = Hash[*matchday.to_a.at(index)].values[0]
        second_team = Hash[*matchday.to_a.at(index + 1)].values[0]
        index += 2

        increment_score(standings, first_team, second_team)
        increment_score(standings, second_team, first_team)
      end

      sorted_standings = sort_standings(standings)
      print_matchday(matchday_number, sorted_standings)

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

  num_games = matchday.length / 2
  index = 0

  num_games.times do
    first_team = Hash[*matchday.to_a.at(index)].values[0]
    second_team = Hash[*matchday.to_a.at(index + 1)].values[0]
    index += 2

    increment_score(standings, first_team, second_team)
    increment_score(standings, second_team, first_team)
  end

  sorted_standings = sort_standings(standings)
  print_matchday(matchday_number, sorted_standings)

when 0
  # queue = []
  # Thread.new do
  #   loop do
  #     input = gets.chomp
  #     exit if input == 'exit'

  #     queue << input
  #   end
  # end

  # loop do
  #   unless queue.empty?
  #     next_line = queue.shift
  #     parser.parse_line(next_line, league)
  #   end
  # end
end

# todo - need to handle the case where there are extra args
