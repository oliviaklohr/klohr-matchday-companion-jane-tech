#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

require_relative '../lib/match_functions.rb'

inputFile = ARGV

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
  teamData = team.split(' ')
  score = teamData.pop.to_i
  name = teamData.join(' ')

  [name, score]
end

def score_match(team_one, team_two)
  if team_one[:score] > team_two[:score]
    3
  else
    team_one[:score] == team_two[:score] ? 1 : 0
  end
end

case inputFile.length
when 1
  # todo: need to make sure file exists / is the right type before we do this
  IO.foreach(inputFile[0]) do |line|
    index = 0

    one, two = line.split(', ')
    team_one_name, team_one_score = separate_team_name_and_score(one)
    team_two_name, team_two_score = separate_team_name_and_score(two)

    team_one = Team.new(team_one_name, team_one_score)
    team_two = Team.new(team_two_name, team_two_score)

    teams = [team_one, team_two]

    if (matchday.key?(team_one.name) || matchday.key?(team_two.name))
      stashed_values = teams

      num_games = matchday.length / 2

      num_games.times do
        first_team = Hash[*matchday.to_a.at(index)].values[0]
        second_team = Hash[*matchday.to_a.at(index + 1)].values[0]
        index += 2

        if standings.key?(first_team[:name])
          current_score = standings[first_team[:name]][:score]
          standings[first_team[:name]] = { score: current_score + score_match(first_team, second_team) }
        else
          standings[first_team[:name]] = { score: score_match(first_team, second_team) }
        end

        if standings.key?(second_team[:name])
          current_score = standings[second_team[:name]][:score]
          standings[second_team[:name]] = { score: current_score + score_match(second_team, first_team) }
        else
          standings[second_team[:name]] = { score: score_match(second_team, first_team) }
        end
      end

      sorted_standings = standings.sort_by { |k,v| [-v[:score], k] }

      puts "Matchday #{matchday_number}"
      sorted_standings.each_with_index do |record, index|
        puts "#{record[0]}: #{record[1][:score]}" if index <= 2
      end
      puts ''

      # "write" teams from `stashedValues` into matchDayTemp
      # puts "ddd matchday: #{matchday}"
      matchday = {}
      teams.each do |team|
        matchday[team.name] = { name: team.name, score: team.score }
      end
      stashed_values = nil
      matchday_number += 1
      # next;
    else
      teams.each do |team|
        matchday[team.name] = { name: team.name, score: team.score }
      end
    end
  end

  # handle last call for last matchday
  puts teams

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
