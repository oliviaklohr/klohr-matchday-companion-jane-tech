# Thoughts and Decisions

You'll find my initial thoughts, edge cases, and notes on any reasons for my choices here!

## Logic Flow

### Step 1: Parse Data

- Validate line format.
  - Skip over bad lines.
- Break line into an array of teams
  - hold in `Team` struct with shape `{ name: 'xyz', score: 1 }`

### Step 2: Create a `Matchday` Object

- Create an object of matches that belong to a given day.
  - To do this, look at each line, break it into teams, and add it to a matchday object **IF** one of those teams is not already part of the matchday.
  - If the team is already in the match day, save it into a "stash" variable so you don't lose it, since you can't undo a read line.
- Note: this object will be reset at the end of every matchday.

### Step 3: Score the Games and Create a `Standings` Object

- Determine which team won, lost, or tied.
- Add that team and their score to the `standings` object.
  - If the team already exists in the `standings` object, just increment their score.
- Note: this object will not be reset at the end of a matchday so that running totals of score can be kept.

### Step 4: Sort the Standings and Print Top Three Teams

- Sort the standings first by score, then alphabetically by team name
  - Make sure to reverse the score sort, since numerical sorting wants to go from small -> big.
- Print only the top three teams.

### Step 5: Continue

- Starting with the "stashed" value, continue parsing the matchday until you reach the end of the file or the exit condition.
- Note: reading the next line in early & using it as a means of determining when all teams are read in means that we have to call all of our `score` and `output` functionality separately one last time outside of the file read-in to get the last matchday to print. This is okay and functional, just not the prettiest since it isn't as DRY as it could be.

## Edge Cases

These are the edge cases I noted and made sure to handle:

- The file does not exist.
- The file is in the wrong format.
- A line has a value of `''`, `' '`, or is lacking a comma with which to "split" the line with (i.e. there's no second team).
  - Skip it, don't error.
- The stream is interrupted.
  - Print out the matchday, regardless if it is complete.
  - This is potentially the only time you will see a matchday printed with less than three teams - if only two teams have played, it will still print with just the two records.

## Technical Decisions

Just some information about why I made several of the implementation choices I did. 😄

### Ruby as the Language of Choice

Most of my recent programming experience has been in Ruby, but my introduction to the language actually came from writing shell scripts in Ruby in college. So despite it being the most logical choice with my background, it was also fun to take on a "throw back" attitude and go back to my roots.

### File Read In

I opted to use `IO.foreach` rather than `File.readlines` or some of the other, more common options I've seen due to the fact that `IO.foreach` **does not** read every line into memory at once, which will be very helpful for large datasets.

### Piped Data

I opted to use a thread to read in piped data in this functionality as kind of a bonus. By using the thread, you can run the command without arguments in two different ways. Running `cat given-documentation/sample-input.txt | bin/main.rb` will handle the piped data as expected, but running just `bin/main.rb` will allow you to input the data line-by-line.

While this wasn't part of the requirements, I opted to do this because when I imagined the "use" of a program like this, I imagined an announcer sitting in a press box at a tournament, uploading match scores line-by-line as he received the game outcomes. This might be a bit of overkill, but it was fun to implement the thread, it still achieved the goal, and it gives an extra bit of bonus functionality.

## Improvements

- In a perfect world, I would loved to have DRY'd (DRYed? neither of those look right haha) up the code a bit more. Several of my methods don't completely abide by the single responsibility principle either, which isn't the most ideal.
- While I obfuscated a fair amount of this functionality into [matchday_companion.rb](lib/matchday_companion.rb), most of that functionality might benefit from being restructured into its own classes. I put my methods into `MatchdayCompanion::Parser` so as to increase the ease of testing and data storage given time constraints, but some of the functionality could have been better handled.
- I tested all of the methods in [matchday_companion.rb](lib/matchday_companion.rb) within [matchday_companion_spec.rb](spec/lib/matchday_companion_spec.rb), but ideally we would also test the `main.rb` file as well. I only opted to forgo this in respect of time, but it is definitely unideal.
- RSpec isn't really meant to test CLI applications, either, so we'd likely be better to pick a different framework.
