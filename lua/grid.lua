--- A utility class for a 2-D grid

---@class Grid
---@field width integer The width of the grid
---@field height integer The height of the grid
---@field cells any[][] The actual 2D Grid
local Grid = {}
Grid.__index = Grid

--- Instantiate a new Grid with a 2D array of arrays
---@param cells any[][]
---@return Grid
function Grid.new(cells)
  local grid = setmetatable({ cells = cells }, Grid)
  if #cells > 0 then
    grid.height = #cells
    grid.width = #cells[1]
  else
    grid.height = 0
    grid.width = 0
  end
  return grid
end

--- Utility function to load a grid from rows of text.
---
--- Splits rows on newline chars and uses one char per column.
---@param text string the text to load in
---@return Grid
function Grid.from_text(text)
  local result = Grid.new({})

  local width = text:find("\n")
  if width == nil then
    result.width = text:len()
  else
    result.width = width
  end

  for row in text:gmatch("[^\n]+") do
    local chars = {}
    for c in row:gmatch(".") do
      result.height = result.height + 1
      table.insert(chars, c)
    end
    table.insert(result.cells, chars)
  end
  return result
end

--- Convert a Grid to a displayable 2D string
---@return string
function Grid:__tostring()
  local result = {}
  for _, row in ipairs(self.cells) do
    table.insert(result, table.concat(row, ""))
  end
  return table.concat(result, "\n")
end

---@alias ReduceFunc fun(cells: any[][], x: integer, y: integer, c: any): any

--- Run a function that gets accumulated accross every row and column of the
--- grid.
---@param func ReduceFunc The function to run on every cell which returns a value
---@param initial any The starting value.  All results of `func` will get added
---     to this, accumulatively.
---@return any Returns the total "sum" of func being run on every cell.
function Grid:reduce(func, initial)
  local acc = initial

  for y, row in ipairs(self.cells) do
    for x, c in ipairs(row) do
      acc = acc + func(self.cells, x, y, c)
    end
  end
  return acc
end

---@alias ForEachFunc fun(cells: any[][], x: integer, y: integer, c: any): nil

--- Runs a function that doesn't return anything on each cell.
---@param func ForEachFunc
function Grid:for_each(func)
  for y, row in ipairs(self.cells) do
    for x, c in ipairs(row) do
      func(self.cells, x, y, c)
    end
  end
end

--- Add padding item `c` to a grid, in-place.
---@param c any Item to add as padding around top, bottom, and sides.
function Grid:pad(c)
  for _, row in ipairs(self.cells) do
    table.insert(row, 1, c)
    table.insert(row, c)
  end
  local top = {}
  local bottom = {}
  for _ = 1, self.width + 2 do
    table.insert(top, c)
    table.insert(bottom, c)
  end
  table.insert(self.cells, 1, top)
  table.insert(self.cells, bottom)
  self.height = self.height + 2
  self.width = self.width + 2
end

return Grid
