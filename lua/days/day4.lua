--[[-
Day 4: Printing Department

Help forklifts lift paper rolls.
]]

local Day = require("day")
local Grid = require("grid")

local day4 = setmetatable({}, Day)

--- Parse the input text into a padded Grid.
---@param contents string
---@return Grid
function day4:parse(contents)
  local result = Grid.from_text(contents)
  result:pad(".")
  return result
end

--- Return the number of adjacent non-"@" chars for a cell
---@param cells string[][] 2D Grid of characters
---@param x integer X index of current position
---@param y integer Y index of current position
---@return integer
local function adjacent_rolls(cells, x, y)
  local rolls = 0
  for i = -1, 1 do
    for j = -1, 1 do
      if not (i == 0 and j == 0) and cells[y + j][x + i] ~= "." then
        rolls = rolls + 1
      end
    end
  end
  return rolls
end

---@type ReduceFunc Return 0 if the cell is not lonely and 1 if it is
local function is_lonely(cells, x, y, c)
  if c ~= "@" then
    return 0
  end
  local rolls = adjacent_rolls(cells, x, y)
  if rolls < 4 then
    cells[y][x] = "x"
    return 1
  end
  return 0
end

--- Part 1: How many "lonely" rolls (< 4 roll neighbors) can be removed.
---@param data Grid
---@return integer
function day4:part1(data)
  local count = data:reduce(is_lonely, 0)
  return count
end

--- Part 2: After repeatedly removing lonely rolls, how many total can be
--- removed.
---@param data Grid
---@return integer
function day4:part2(data)
  local total = 0
  while true do
    local count = data:reduce(is_lonely, 0)
    if count == 0 then
      break
    end
    total = total + count
    data:for_each(function(cells, x, y, c)
      if c == "x" then cells[y][x] = "." end
    end)
  end
  -- print(data)
  return total
end

--- Run the main function for the day.
---
--- This override was needed because we had to reset the grid between parts
--- 1 and 2
---@param infile string The path to the file to be read in.
function day4:run(infile)
  local contents = self:load(infile)
  print("Part 1: " .. self:part1(self:parse(contents)))
  print("Part 2: " .. self:part2(self:parse(contents)))
end

return day4
