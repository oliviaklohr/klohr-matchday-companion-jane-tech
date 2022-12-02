# Thoughts and Decisions

You'll find my initial thoughts, edge cases, and notes on any reasons for my choices here!

## Logic Flow

### Step 1: Parse Data

- Validate line format.
  - Skip over bad lines.
- Break line into an array of teams
  - Store in `Team` struct with shape `{ name: 'xyz', score: 1 }`

### Step 2: Create a `Matchday` Object

- Create an object of matches that belong to a given day.
  - To do this, look at each line, break it into teams, and add it to a matchday object **IF** one of those teams is not already part of the matchday.
  - If the team is already in the match day, save it into a "stash" variable to prevent its loss, as we do not "reread" lines.
- Note: this object is emptied at the end of every matchday.

### Step 3: Score the Games and Create a `Standings` Object

- Determine the new resulting scores as a result of each match.
  - If a team is already present in the `standings` object, update their score appropriately.
  - else record the team and their first score.
- Note: this object will not be emptied at the end of a matchday so that a running totals of scores can be maintained.

### Step 4: Sort the Standings and Print Top Three Teams

- Sort the standings first by score, then alphabetically by team name
  - Make sure to reverse the score sort, since numerical sorting defaults to ascending order.
- Print only the three teams with the hightest scores.

### Step 5: Continue

- Starting with the "stashed" value, continue parsing matchday data until you reach the end of the file or `exit` is entered in the command line.
- Note: reading the next line in early & using it as a means of determining when all teams are read in means that we have to call all of our `score` and `output` functionality separately one last time outside of the file parsingto ensure we calculate last matchday to print. This is okay and functional, just not the prettiest since it isn't as DRY as it could be.

## Edge Cases

These are the edge cases I noted and made sure to handle:

- The file does not exist.
- The file is in the wrong format.
- A line has a value of `''`, `' '`, or is lacking a comma with which to "split" the line with (i.e. there's no second team).
  - Skip it, don't error.
- The stream is interrupted.
  - Print out the matchday regardless of completion.
  - This is potentially the only time you will see a matchday printed with less than three teams - if only two teams have played, it will still print with just the two records.

## Technical Decisions

Just some information about why I made several of the implementation choices I did. 😄

### Ruby as the Language of Choice

Most of my recent programming experience has been in Ruby, but my introduction to the language actually came from writing shell scripts in Ruby in college. So despite it being the most logical choice with my background, it was also fun to take on a "throw back" project and go back to my roots.

### File Read In

I opted to use `IO.foreach` rather than `File.readlines` or another, more common option I've seen due to the fact that `IO.foreach` **does not** read every line into memory at once, which will be very helpful for large datasets.

### Piped Data

I opted to use a thread to read in piped data in this functionality as kind of a bonus. By using the thread, you can run the command without arguments in two different ways. Running `cat given-documentation/sample-input.txt | bin/main.rb` will handle the piped data as expected, but running just `bin/main.rb` will allow you to input the data line-by-line.

While this wasn't part of the requirements, I opted to do this because when I considered use-cases for a program such as this, I imagined an announcer sitting in a press box at a tournament, uploading match scores line-by-line as he received various game outcomes. This might be a bit overkill, but it was fun to implement the thread, it still achieved the goal, and it provides a bit of extra bonus functionality.

## Improvements

- In a perfect world, I would loved to have DRY'd (DRYed? neither of those look right haha) up the code a bit more. Several of my methods don't completely abide by the single responsibility principle either, which isn't the most ideal.
- While I obfuscated a fair amount of this functionality into [matchday_companion.rb](lib/matchday_companion.rb), much of that additional functionality within this project might benefit from being restructured into additional classes. I put my methods into `MatchdayCompanion::Parser` so as to increase the ease of testing and data storage given time constraints, but some of the functionality could have been better handled.
- I tested all of the methods in [matchday_companion.rb](lib/matchday_companion.rb) within [matchday_companion_spec.rb](spec/lib/matchday_companion_spec.rb), but ideally we would also test the `main.rb` file as well. I only opted to forgo this in respect of time, but would look to implement tests for `main.rb` in the future, were I to have more time.
- RSpec isn't really meant to test CLI applications, either, so we'd likely be better to pick a different testing framework.
