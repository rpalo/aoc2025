local Day = {}
Day.__index = Day

function Day:load(infile)
  io.input(infile)
  return io.read("*all")
end

function Day:parse(contents)
  return contents
end

function Day:part1(data)
  return "todo"
end

function Day:part2(data)
  return "todo"
end

function Day:run(infile)
  local contents = self:load(infile)
  local data = self:parse(contents)
  print("Part 1: " .. self:part1(data))
  print("Part 2: " .. self:part2(data))
end

return Day
