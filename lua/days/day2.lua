--[[-
Day 2: Gift Shop

Find numbers within ranges that are just a little *too* silly.
]]

local Day = require("day")
local day2 = setmetatable({}, Day)

---@class day2.Range
---@field start number The start of the range
---@field finish number The end of the range
local Range = {}

function Range:__tostring()
  return string.format("%d - %d", self.start, self.finish)
end

--- Instantiate a new Range
function Range.new(start, finish)
  return setmetatable({ start = tonumber(start), finish = tonumber(finish) }, Range)
end

day2.Range = Range

--- Parse out the input file into ranges
---@param contents string The string puzzle input
---@return day2.Range[] A list of integer ranges
function day2:parse(contents)
  local result = {}
  for range in contents:gmatch("[^,]+") do
    if range:len() > 0 then
      local start, finish = string.match(range, "(%d+)-(%d+)")
      table.insert(result, Range.new(start, finish))
    end
  end
  return result
end

--- Return the number of digits in a number
---@param n integer
---@return integer
local function digits(n)
  return math.floor(math.log(n, 10)) + 1
end

--- Generate the next number that consists of a number repeated twice
---@param n integer
---@return integer The next number in the sequence.
local function next_repeated(n)
  if n < 1 then
    n = 1
  end

  local d = digits(n)
  -- Skip all numbers with an odd number of digits
  if d % 2 == 1 then
    n = 10 ^ d
    d = d + 1
  end

  local half_power = 10 ^ (d / 2)
  local front = math.floor(n / half_power)
  local back = math.floor(n % half_power)

  -- bump up the front number if the back number is past it
  if back >= front then
    front = front + 1
  end

  if digits(front) > d / 2 then
    half_power = half_power * 10
  end

  return math.floor(front * half_power + front)
end

--- Iterate and yield over all the doubled numbers between start and finish,
--- inclusive
--- @param start integer
--- @param finish integer
--- @return fun(): integer | nil
local function iter_doubled(start, finish)
  local current = start - 1
  return function()
    current = next_repeated(current)

    if current > finish then
      return nil
    end
    return current
  end
end

--- Part 1: Sum up all the numbers in the given ranges that are made up of
--- a smaller number made twice
---@param data day2.Range[]
---@return integer
function day2:part1(data)
  local total = 0
  for _, range in ipairs(data) do
    for n in iter_doubled(range.start, range.finish) do
      total = total + n
    end
  end
  return total
end

--- Repeat the given `front` value `times` times to generate a new number
---@param front integer A number to be repeated
---@param times integer How many times to repeat it
---@return integer The resultant number
local function repeat_front(front, times)
  local result = 0
  local size = digits(front)
  for _ = 1, times do
    result = result * 10 ^ size + front
  end
  return result
end

--- Return true if `n` consists of only a single digit repeated 0 or more times
---@param n integer
---@return boolean
local function all_same_digit(n)
  local first = n % 10
  while n > 0 do
    if n % 10 ~= first then
      return false
    end
    n = math.floor(n / 10)
  end
  return true
end

--- Return the next repeated number using `size` as the repeated chunk size
---
--- Very similar logic to the above generation function, but generalized for
--- multiple repeats possible.
---
--- Note: because 1 isn't prime, it's a hard-coded edge case to not include
--- numbers that are all the same digit unless specifically asked for a `size`
--- of 1.
---@param n integer The generated number will definitely be larger than `n`
---@param size integer How many digits long is the repeated section
---@return integer The next repeated number
local function next_repeated_of_size(n, size)
  if n < 10 ^ (size * 2 - 1) then
    return math.floor(repeat_front(10 ^ (size - 1), 2))
  end
  local d = digits(n)
  local repeats = math.ceil(d / size)

  if d % size ~= 0 then
    n = 10 ^ (repeats * size - 1)
    d = size * repeats
  end

  local front = math.floor(n / 10 ^ (d - size))

  if all_same_digit(front) and size ~= 1 then
    front = front + 1
  end

  local result = repeat_front(front, repeats)
  if n < result then
    return math.floor(result)
  end

  front = front + 1

  if all_same_digit(front) and size ~= 1 then
    front = front + 1
  end

  if digits(front) > size then
    front = 10 ^ (size - 1)
    return math.floor(repeat_front(10 ^ (size - 1), repeats + 1))
  end

  return math.floor(repeat_front(front, repeats))
end

--- Iterate over all the repeated numbers with repeat segment of size `size`
--- between `start` and `finish`, inclusive.
---@param start integer
---@param finish integer
---@param size integer
---@return fun(): integer | nil
local function iter_size_repeated(start, finish, size)
  local current = start - 1
  return function()
    current = next_repeated_of_size(current, size)
    if current > finish then
      return nil
    end
    return current
  end
end

--- Iterate over all repeated numbers between `start` and `finish`, inclusive
--- for any size of repeated segment, as long as it's a complete repeat
---@param start integer
---@param finish integer
local function iter_repeated2(start, finish)
  for size = 1, 5 do -- biggest number is 10 digits, so 1-5 is enough
    for n in iter_size_repeated(start, finish, size) do
      coroutine.yield(n)
    end
  end
end

--- Part 2: Sum up all unique numbers made up of 2 or more repeating sub-numbers
---@param data day2.Range[]
---@return integer
function day2:part2(data)
  local total = 0
  local numbers = {}
  for _, range in ipairs(data) do
    local iter = coroutine.wrap(function()
      iter_repeated2(range.start, range.finish)
    end)

    for n in iter do
      if not numbers[n] then
        total = total + n
        numbers[n] = true
      end
    end
  end
  return total
end

return day2
