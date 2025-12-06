--[[-
Day 5: Cafeteria

Check how fresh ingredients in the kitchen are.
]]

local Day = require("day")
local Range = require("range")

local day5 = setmetatable({}, Day)

local inspect = require("inspect")

function day5:parse(contents)
  local ranges = {}
  local ids = {}

  for start, finish in contents:gmatch("(%d+)-(%d+)") do
    start = tonumber(start)
    finish = tonumber(finish)
    assert(start ~= nil and finish ~= nil, "Bad range parse.")
    table.insert(ranges, Range.new(start, finish))
  end

  for id in contents:gmatch("\n(%d+)%f[\n]") do
    id = tonumber(id)
    assert(id ~= nil, "Bad id parse.")
    table.insert(ids, id)
  end
  return ranges, ids
end

local function merge_all(ranges)
  if #ranges == 1 then
    return ranges
  end

  local result = {}
  local current = ranges[1]
  local failed = nil

  for i = 2, #ranges do
    current, failed = current:merge(ranges[i])
    if failed then
      table.insert(result, current)
      current = failed
    end
  end
  table.insert(result, current)
  return result
end

local function in_ranges(id, ranges)
  for _, range in ipairs(ranges) do
    if range:contains(id) then
      return true
    end
  end
  return false
end

function day5:part1(ranges, ids)
  local count = 0
  for _, id in ipairs(ids) do
    if in_ranges(id, ranges) then
      count = count + 1
    end
  end
  return count
end

function day5:part2(ranges, _)
  local total = 0
  for _, range in ipairs(ranges) do
    total = total + (range.finish - range.start + 1)
  end
  return total
end

function day5:run(infile)
  local contents = self:load(infile)
  local ranges, ids = self:parse(contents)
  table.sort(ranges)
  ranges = merge_all(ranges)
  print("Part 1: " .. self:part1(ranges, ids))
  print("Part 2: " .. self:part2(ranges, ids))
end

return day5
