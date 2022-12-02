# Matchday Companion

Friends at Jane Technologies 💛 - hey! Just wanted to say thanks for putting this together - I enjoyed the challenge of working through this.

## Details

This project is using Ruby version `3.1.2` and has been run / created on a 2022 MacBook Air running MacOS Monterey `v12.5`.

For insight into my thought process on creating this solution, please see [thoughts.md](thoughts.md). This file isn't incredibly organized, but exists primarily as a means for myself to document my thoughts along the way, which I figured you all might enjoy reading 🙂.

## Usage

Note: Should you get a warning about `main.rb` being unexecutable, please run the following command: `chmod +x bin/main.rb` 🙂

1. Run `bundle install` to ensure all dependencies are installed on your machine.
2. The command `rspec` will run all associated tests.
3. The Matchday Companion can be run in a variety of ways:
   1. Run `bin/main.rb` without any arguments to input match data via the console line-by-line.
   2. Run `cat <FILE> | bin/main.rb` to pipe the file into the program.
   3. Run `bin/main.rb given-documentation/sample-input.txt` to input match data via a file.

## Assumptions

- Each team plays every day.
- File input is just a `.txt` file with comma-delimited strings.
- Team names don't have commas in them.
- I validate a several malformed bad strings (`''`, `' '`, and `'Santa Cruz Slugs 3`), but I did assume that the format would be `Santa Cruz Slugs 3, Aptos FC 2`. Or, in other words, I am not enforcing that lines are of the `<String> <Num>, <String> <Num>` format.
