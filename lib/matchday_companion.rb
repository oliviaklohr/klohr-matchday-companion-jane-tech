# frozen_string_literal: true

module MatchdayCompanion
  Team = Struct.new(:name, :score)

  class Parser
    def valid_line_format?(line)
      return false if ['', ' '].include?(line) # get rid of blank lines
      return false unless line.split(',').length > 1 # get rid of lines without two teams

      true
    end

    def define_teams(line)
      one, two = line.split(', ')
      team_one_name, team_one_score = separate_team_name_and_score(one)
      team_two_name, team_two_score = separate_team_name_and_score(two)

      team_one = Team.new(team_one_name, team_one_score)
      team_two = Team.new(team_two_name, team_two_score)

      [team_one, team_two]
    end

    def increment_score_and_print_matchday(matchday, matchday_number, standings)
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
    end

    # private
    # NOTE: I left this commented out so I could test these functions,
    # but theoretically, everything below this line could be private.

    def separate_team_name_and_score(team)
      team_data = team.split
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
      standings.sort_by { |k, v| [-v[:score], k] }
    end
  end
end
