--[[-
Day 7: Laboratories

Split tachyon beams with ascii
]]

local Day = require("day")

local day7 = setmetatable({}, Day)

--- Parse the input into a sparse grid of the splitter locations, plus the
--- starting X location in the top row, and the total height.
---@param contents string The text contents of the input file.
---@return boolean[][] splitters The locations of the splitters
---@return integer start_x Where the start location is
---@return integer height The total height of the grid
function day7:parse(contents)
  local splitters = {}
  local row = 0
  local width = contents:find("\n")
  local start_x = 0
  for line in contents:gmatch("[^\n]+") do
    row = row + 1
    splitters[row] = {}
    for i = 1, width do
      if line:sub(i, i) == "^" then
        splitters[row][i] = true
      elseif line:sub(i, i) == "S" then
        start_x = i
      end
    end
  end
  return splitters, start_x, row
end

--- Find out how many splits happen, i.e. how many of the splitters get activated
---@param splitters boolean[][]
---@param start_x integer
---@param height integer
---@return integer
function day7:part1(splitters, start_x, height)
  local splits = 0
  local beams = { [start_x] = true }

  for y = 2, height do
    local new_beams = {}

    for x, _ in pairs(beams) do
      if splitters[y][x] then
        new_beams[x - 1] = true
        new_beams[x + 1] = true
        splits = splits + 1
      else
        new_beams[x] = true
      end
    end
    beams = new_beams
  end
  return splits
end

--- Part 2: Count how many unique possibilities of splitter hits occur
---@param splitters boolean[][]
---@param start_x integer
---@param height integer
---@return integer
function day7:part2(splitters, start_x, height)
  local beams = { [start_x] = 1 }

  for y = 2, height do
    local new_beams = {}

    for x, _ in pairs(beams) do
      if splitters[y][x] then
        new_beams[x - 1] = (new_beams[x - 1] or 0) + beams[x]
        new_beams[x + 1] = (new_beams[x + 1] or 0) + beams[x]
      else
        new_beams[x] = (new_beams[x] or 0) + beams[x]
      end
    end
    beams = new_beams
  end

  local total = 0
  for _, count in pairs(beams) do
    total = total + count
  end
  return total
end

--- Main run function
function day7:run(infile)
  local contents = self:load(infile)
  local splitters, start_x, height = self:parse(contents)
  print("Part 1: " .. self:part1(splitters, start_x, height))
  print("Part 2: " .. self:part2(splitters, start_x, height))
end

return day7
