---@class Range
---@field start number The start of the range
---@field finish number The end of the range
local Range = {}
Range.__index = Range

function Range:__tostring()
  return string.format("%d - %d", self.start, self.finish)
end

--- Instantiate a new Range
---@param start integer The start of the range, inclusive
---@param finish integer The end of the range, inclusive
---@return Range
function Range.new(start, finish)
  return setmetatable({ start = tonumber(start), finish = tonumber(finish) }, Range)
end

function Range:merge(other)
  if (
        (self.finish >= other.start and self.start <= other.finish) or
        (other.finish >= self.start and other.start <= self.finish)
      ) then
    return Range.new(math.min(self.start, other.start), math.max(self.finish, other.finish)), nil
  end
  return self, other
end

function Range:__lt(other)
  if type(other) == "number" then
    return self.finish < other
  elseif getmetatable(self) == getmetatable(other) then
    return self.start < other.start
  else
    error("Couldn't compare a Range to a " .. type(other))
  end
end

function Range:contains(v)
  return v >= self.start and v <= self.finish
end

return Range
