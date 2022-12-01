# Matchday Companion

Friends at Jane Technologies - hey! Just wanted to say thanks for putting this together - I enjoyed the challenge of working through this.

## Details

This project is using Ruby version `3.1.2` and has been run / created on a 2022 MacBook Air running MacOS Monterey `v12.5`.

For insight into my thought process on creating this solution, please see [thoughts.md](thoughts.md). This file isn't super organized, but exists to document how I think in scenarios like this one.

## Usage

1. Run `bundle install` to ensure all dependencies are installed on your machine.
2. Run `chmod +x bin/main.rb` <!-- TODO: Figure out how to not have to do this lol. There's gotta be a way. -->
3. The command `rspec` will run all associated tests.
4. Run `bin/main.rb` without any arguments to input match data via the console line-by-line
OR
Run `bin/main.rb given-documentation/sample-input.txt` to input match data via a file.

## Assumptions

- each team plays every day

