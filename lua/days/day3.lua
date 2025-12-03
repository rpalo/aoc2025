--[[-
Day 3: Lobby

Fix Escalators with **Joltage**
]]

local Day = require("day")

local day3 = setmetatable({}, Day)

--- Parse the input text into rows if integers
---@param contents string
---@return integer[][]
function day3:parse(contents)
  local result = {}
  for row in contents:gmatch("[^\n]+") do
    local values = {}
    for c in row:gmatch("%d") do
      table.insert(values, tonumber(c))
    end
    table.insert(result, values)
  end
  return result
end

--- Find the largest number possible by selecting `remaining` digits, squashing
--- them together in order.
---
---@param numbers integer[] A list of numbers to use as a digit source
---@param start integer The index to start searching on
---@param remaining integer How many more numbers there are to select
---@return integer
function day3.find_highest_n(numbers, start, remaining)
  if remaining == 0 then
    return 0
  end

  local highest = 0
  local highest_i = 0

  for i = start, #numbers - remaining + 1 do
    local n = numbers[i]
    if n > highest then
      highest = n
      highest_i = i
    end
    if highest == 9 then
      break
    end
  end

  return highest * 10 ^ (remaining - 1) + day3.find_highest_n(numbers, highest_i + 1, remaining - 1)
end

--- Part 1: Find the sum of each row's largest 2-digit number
---@param data integer[][]
---@return integer
function day3:part1(data)
  local total = 0
  for _, row in ipairs(data) do
    total = total + self.find_highest_n(row, 1, 2)
  end
  return total
end

--- Part 2: Find the sum of each row's largest 12-digit number
---@param data integer[][]
---@return integer
function day3:part2(data)
  local total = 0
  for _, row in ipairs(data) do
    local find = self.find_highest_n(row, 1, 12)
    total = total + find
  end
  return math.floor(total)
end

return day3
