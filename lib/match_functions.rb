# frozen_string_literal: true
require 'pry'

module MatchFunctions
  TeamData = Struct.new(:team_name, :score)

  class Team
    attr_accessor :name, :match_outcomes

    def initialize(name)
      @name = name
      @match_outcomes = []
    end

    def num_played
      @match_outcomes.size
    end

    def total_score
      @match_outcomes.sum
    end
  end

  class Match
    attr_accessor :matchday, :team_one, :score_one, :team_two, :score_two

    def initialize(team_one, score_one, team_two, score_two)
      @team_one = team_one
      @score_one = score_one
      @team_two = team_two
      @score_two = score_two
    end

    def score_match(a, b)
      if a > b
        3
      else
        a == b ? 1 : 0
      end
    end
  end

  class League
    attr_accessor :teams_in_league, :matches, :daily_matches

    def initialize
      @teams_in_league = []
      @matches = []
      @rank = []
    end

    def add_teams_to_league(names)
      names.each do |team_name|
        @teams_in_league << MatchFunctions::Team.new(team_name) unless @teams_in_league.any? { |team| team.name == team_name }
      end
    end

    def add_matches_to_league(match)
      @matches << match
    end
  end

  class Parser
    def parse_line(line, league, all_teams_entered)
      # TODO: validate that line is correct format

      team_uno, team_dos = get_teams_from_line(line)

      team_one_name, team_one_score = separate_team_name_and_score(team_uno)
      team_two_name, team_two_score = separate_team_name_and_score(team_dos)

      @team_one = TeamData.new(team_one_name, team_one_score) # might need an if this doesn't exist case
      @team_two = TeamData.new(team_two_name, team_two_score)

      league.add_teams_to_league([@team_one.team_name, @team_two.team_name])
      repeat_teams = league.teams_in_league.any? { |team| team.name == @team_one.team_name || team.name == @team_two.team_name }

      # team_one_points = score_match(team_one_score, team_two_score)
      # team_two_points = score_match(team_two_score, team_one_score)

      match = MatchFunctions::Match.new(@team_one, team_one_score, @team_two, team_two_score)

      # team_one_points = match.score_match()
      # team_two_points = match.score_match()
      league.add_matches_to_league(match)

      if all_teams_entered
        matches_per_day = league.teams_in_league.length / 2
        # puts "matches_per_day: matches_per_day

        new_match_day = league.matches.length % matches_per_day == 0
        # puts "new_match_day: #{new_match_day}"

        puts "Match Day #{league.matches.length / matches_per_day}" if new_match_day
        puts "matches: #{league.matches.length}" if new_match_day
      end

      if repeat_teams
        return true
      else
        return false
      end

      # @teams_in_league where name == @team_one.name -> match_outcomes << team_one_points
      # @team_two.match_outcomes << team_two_points

      # league.teams_in_league.length / 2 is number of games per match day

      # generate match


    end

    def get_teams_from_line(line)
      team_one, team_two = line.split(', ')
    end

    # separates the team name and score
    def separate_team_name_and_score(team)
      teamData = team.split(' ')
      score = teamData.pop.to_i
      name = teamData.join(' ')

      [name, score]
    end

    # score the match accordingly
    def score_match(team_one_score, team_two_score)
      if team_one_score > team_two_score
        3
      else
        team_one_score == team_two_score ? 1 : 0
      end
    end
  end
end