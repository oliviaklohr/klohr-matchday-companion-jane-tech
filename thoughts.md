# thoughts

You'll find my initial thoughts, edge cases, and notes here!

## step: read in file

- collect teams into an array
- before adding a team to the array, check to see if it is already there
- once you get your first duplicate, that's all the teams
- can use `array.length / 2` at this point to know how many games per matchday.

## step: score games

- matchday total is a RUNNING score - don't want to reset each matchday
  - win: +3 points
  - tie: +1 point
  - loss: 0

## step: output

- only output top three teams, no matter how many are included.
- ordered first by score, tiebreaker is alphabetical

## edge cases

- file does not exist
- file is wrong format
- skip bad lines <- requirement
- handle interrupted i/o resulting in incomplete matchday