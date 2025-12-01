# Advent of Code 2025 Solutions

Spoiler alert, this code contains my solutions to 2025 Advent of Code, in Lua.

Per the FAQ on the AoC website, I'm not pushing my input data files, so you'll
just have to trust me that it works. I'll try to post the run times for each
stage when I remember.

Before this event, I knew Lua on a day-to-day level, and I use it to configure
Neovim, but I wanted to use AoC 2025 as an excuse to do things "properly." It's
clear that a large portion of the Lua community is in the "there is not really
one specific way to do stuff, we're not very particular about it, just do what
works for you" camp, which makes things harder, but I'm trying to pick out
nuggets and apply some nice engineering from other languages I know without
fully squashing the Lua Freedom spirit. Definitely not trying to shoehorn in a
rigid Java-like OOP structure, unless it absolutely makes sense in that
use-case.

## Running the Solutions

The main script assumes the input data files are placed in `data/dayN.txt` (and
test files in `data/dayN_test.txt`). If you had data files in place, you could
run `bin/aoc` to run all the solutions, use the `--test` flag to swap to using
test files, and the `--day N` option to instead just run one specific day.

## Tests

Tests can be run with `luarocks test`, assuming you have `busted` installed and
your env vars pointed right. I've had a bit of a tricky time pointing my lua
install, luarocks, and busted all in the same direction and referencing the same
versions and environments, but that's on me to learn more about.

The tests assume that the test inputs specified in the puzzle prompts are placed
in `data/dayN_test.txt`.
