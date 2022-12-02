# frozen_string_literal: true

require 'matchday_companion'

RSpec.describe MatchdayCompanion do
  describe MatchdayCompanion::Parser do
    let(:parser) { MatchdayCompanion::Parser.new }

    context 'valid_line_format?' do
      let(:line) { '' }

      it 'returns false if the line is an empty string (invalid)' do
        expect(parser.valid_line_format?(line)).to eq(false)
      end

      it 'returns false if the line is an blank string (invalid)' do
        line = ' '
        expect(parser.valid_line_format?(line)).to eq(false)
      end

      it 'returns false if the line is not comma delimited (invalid - only one team)' do
        line = 'Santa Cruz Slugs 3'
        expect(parser.valid_line_format?(line)).to eq(false)
      end

      it 'returns false if the line contains more than 2 teams (invalid)' do
        line = 'Santa Cruz Slugs 3, Aptos FC 2, Sporting KC 9'
        expect(parser.valid_line_format?(line)).to eq(false)
      end
    end

    context 'define_teams' do
      let(:line) { 'Santa Cruz Slugs 3, Aptos FC 2' }

      it 'returns the teams in the `Team` struct' do
        team_one, team_two = parser.define_teams(line)

        expect(team_one.name).to eq('Santa Cruz Slugs')
        expect(team_two.name).to eq('Aptos FC')
        expect(team_one.score).to eq(3)
        expect(team_two.score).to eq(2)
      end
    end

    context 'increment_score_and_print_matchday' do
      let(:matchday) do
        { 'San Jose Earthquakes' => { name: 'San Jose Earthquakes', score: 3 },
          'Santa Cruz Slugs' => { name: 'Santa Cruz Slugs', score: 3 } }
      end
      let(:matchday_number) { 1 }
      let(:standings) { { 'San Jose Earthquakes' => { score: 1 }, 'Santa Cruz Slugs' => { score: 0 } } }
      let(:sorted_standings) { [['San Jose Earthquakes', { score: 1 }], ['Santa Cruz Slugs', { score: 0 }]] }

      it 'prints the standings' do
        first_team = { name: 'San Jose Earthquakes', score: 3 }
        second_team = { name: 'Santa Cruz Slugs', score: 3 }

        expect(subject).to receive(:increment_score).with(standings, first_team, second_team)
        expect(subject).to receive(:increment_score).with(standings, second_team, first_team)

        expect(subject).to receive(:print_matchday).with(matchday_number, sorted_standings)
        subject.increment_score_and_print_matchday(matchday, matchday_number, standings)
      end
    end

    context 'separate_team_name_and_score' do
      let(:team) { 'Santa Cruz Slugs 3' }

      it 'separates a team from their score' do
        expect(parser.separate_team_name_and_score(team)).to eq(['Santa Cruz Slugs', 3])
      end
    end

    context 'score_match' do
      let(:team_one) { { name: 'Santa Cruz Slugs', score: 3 } }
      let(:team_two) { { name: 'Aptos FC', score: 2 } }

      it 'returns 3 if the first input team wins' do
        expect(parser.score_match(team_one, team_two)).to eq(3)
      end

      it 'returns 0 if the first input team loses' do
        expect(parser.score_match(team_two, team_one)).to eq(0)
      end

      it 'returns 1 if the teams tie' do
        team_two[:score] = team_one[:score]
        expect(parser.score_match(team_two, team_one)).to eq(1)
      end
    end

    context 'increment_score' do
      let(:standings) { { 'San Jose Earthquakes' => { score: 1 }, 'Santa Cruz Slugs' => { score: 0 } } }
      let(:first_team) { { name: 'San Jose Earthquakes', score: 3 } }
      let(:second_team) { { name: 'Santa Cruz Slugs', score: 3 } }

      it 'increments the score in the standings object' do
        expect(parser.increment_score(standings, first_team, second_team)).to eq({ score: 2 })
      end
    end

    context 'sort_standings' do
      let(:standings) do
        { 'San Jose Earthquakes' => { score: 1 }, 'Santa Cruz Slugs' => { score: 1 },
          'Capitola Seahorses' => { score: 3 }, 'Aptos FC' => { score: 0 },
          'Felton Lumberjacks' => { score: 3 }, 'Monterey United' => { score: 0 } }
      end

      it 'sorts the standings first by reverse score & then by name to tie-break' do
        expect(parser.sort_standings(standings)).to eq([['Capitola Seahorses', { score: 3 }],
                                                        ['Felton Lumberjacks', { score: 3 }],
                                                        ['San Jose Earthquakes', { score: 1 }],
                                                        ['Santa Cruz Slugs', { score: 1 }],
                                                        ['Aptos FC', { score: 0 }],
                                                        ['Monterey United', { score: 0 }]])
      end
    end
  end
end
