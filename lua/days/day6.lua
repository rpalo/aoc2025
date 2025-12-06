--[[-
Day 6: Trash Compactor

Help garbage squids do math
]]

local Day = require("day")

local day6 = setmetatable({}, Day)

local function parse_nums_in_rows(contents)
  local rows = {}
  for line in contents:gmatch("[^\n]+") do
    local row = {}
    if line:match("[*+]") then
      for op in line:gmatch("[*+/-]") do
        table.insert(row, op)
      end
    else
      for num in line:gmatch("%d+") do
        table.insert(row, tonumber(num))
      end
    end
    table.insert(rows, row)
  end
  return rows
end

local function pivot(rows)
  local result = {}
  for i = 1, #rows[1] do
    local col = {}
    for j = 1, #rows do
      table.insert(col, rows[j][i])
    end
    table.insert(result, col)
  end
  return result
end

local function add(a, b) return a + b end
local function mul(a, b) return a * b end
local FUNCS = { ["+"] = add, ["*"] = mul }

function day6:part1(contents)
  local rows = parse_nums_in_rows(contents)
  local cols = pivot(rows)
  local total = 0
  for _, eq in ipairs(cols) do
    local op = eq[#eq]
    local func = FUNCS[op]
    local eq_total = eq[1]
    for i = 2, #eq - 1 do
      eq_total = func(eq_total, eq[i])
    end
    total = total + eq_total
  end
  return total
end

local function make_col_number(rows, col)
  local number = 0
  for i = 1, #rows - 1 do
    local digit = tonumber(rows[i]:sub(col, col))
    if digit then
      number = number * 10 + digit
    end
  end
  return number
end

function day6:part2(contents)
  local total = 0

  local rows = {}
  for line in contents:gmatch("[^\n]+") do
    table.insert(rows, line)
  end

  local eq_total = 0
  local func = function(a, b) error("no func found") end

  -- Walk left to right, making column numbers and doing math when we hit
  -- a new operator (or at the end)
  for i = 1, contents:find("\n") do
    local num = make_col_number(rows, i)

    if num == 0 then
      -- blank column, I confirmed there are no columns with zeros in them
    elseif rows[#rows]:sub(i, i) ~= " " then
      -- Operator column, close out the previous equation
      total = total + eq_total
      eq_total = num
      func = FUNCS[rows[#rows]:sub(i, i)]
    else
      eq_total = func(eq_total, num)
    end
  end
  total = total + eq_total
  return total
end

function day6:run(infile)
  local contents = self:load(infile)
  print("Part 1: " .. self:part1(contents))
  print("Part 2: " .. self:part2(contents))
end

return day6
