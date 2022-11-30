#!/usr/bin/env ruby
require 'pry'

# teamName: score
TEAMS = {

}

def parseLine(line)
  # todo: validate that line is correct format

  teamOne, teamTwo = getTeamsFromLine(line)

  teamOneName, teamOneScore = separateTeamNameAndScore(teamOne)
  teamTwoName, teamTwoScore = separateTeamNameAndScore(teamTwo)

  teamOnePoints = scoreMatch(teamOneScore, teamTwoScore)
  teamTwoPoints = scoreMatch(teamTwoScore, teamOneScore)
end

def getTeamsFromLine(line)
  teamOne, teamTwo = line.split(', ')
end

# separates the team name and score
def separateTeamNameAndScore(team)
  teamData = team.split(' ');
  score = teamData.pop.to_i
  name = teamData.join(' ')

  return name, score
end

# score the match accordingly
def scoreMatch(teamOneScore, teamTwoScore)
  teamOneScore > teamTwoScore ? 3 : teamOneScore == teamTwoScore ? 1 : 0
end

# # figure out how many teams are in a match day so we know when to delimit
# def determineTeamsInLeague(line, teamArray)
#   team1, team2 = getTeamsFromLine(line)
#   name1, _ = separateTeamNameAndScore(team1)
#   name2, _ = separateTeamNameAndScore(team2)

#   return teamArray.length if teamArray.include?(name1) || teamArray.include?(name2)
#   teamArray << name1
#   teamArray << name2

#   teamArray
# end

inputFile = ARGV

puts 'Welcome to the Matchday Companion for the Jane Technologies Soccer League!'
puts 'To leave the program at any point in execution, type `exit`.'

if inputFile.length == 1
  # need to make sure file exists / is the right type before we do this
  IO.foreach(inputFile[0]) do |line|
    parseLine(line)
  end
elsif inputFile.length == 0
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
      parseLine(next_line)
    end
  end
else
  # error - too many arguments
  # print usage
end