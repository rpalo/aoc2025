.PHONY: help test run run-test

## Advent of Code 2025
## ===================

help:  ## Show the help
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

test:  ## Run the unit tests
	@luarocks test

run:  ## Run the full aoc
	@bin/aoc

run-test:  ## Run the full aoc with test files
	@bin/aoc --test

.env:  ## Generate the env vars needed to make lua find things correctly
	luarocks env --bin > .env
