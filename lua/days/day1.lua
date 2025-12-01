--[[-
Day 1: Secret Entrance

Unlock a safe to get the secret password.
]]
local day1 = {}

--- A dial is a circle of values that can spin infinitely
local dial = { start_val = 50, size = 100 }
day1.dial = dial

--- Spin the dial `change` amount in `direction` and return the
--- value showing on the dial and how many zero-ticks occurred while
--- spinning.
---@param current integer The current value of the dial
---@param change integer The positive amount to spin the dial
---@param direction "R" | "L" Which direction to spin the dial
---@return integer result The new value showing on the dial
---@return integer ticks How many ticks at zero occurred
function dial:spin(current, change, direction)
    assert(change > 0, "Change must be greater than 0, got " .. change)

    local ticks = math.floor(change / self.size)
    change = change % self.size
    if direction == "L" then
        change = change * -1
    end
    local result = current + change

    if result >= self.size then
        ticks = ticks + 1
        result = result - self.size
    elseif result == 0 then
        ticks = ticks + 1
    elseif result < 0 then
        result = result + self.size
        -- move from zero to negative is not a tick
        if current ~= 0 then
            ticks = ticks + 1
        end
    end
    return result, ticks
end

--- Count the number of zeros encountered while spinning the dial through
--- the provided instructions.
---@param instructions fun(): string An iterator of strings of the form
---     'L30' or 'R104' i.e. an R or L followed by a positive integer.
---@return integer exacts The number of times the dial landed at zero
---     after an instruction
---@return integer passed The number of times the dial passed by zero while
---     spinning, including stops at 0.
function day1:count_zeros(instructions)
    local value = dial.start_val
    local exacts = 0
    local passed = 0
    for line in instructions do
        local amount = tonumber(line:sub(2, -1))
        assert(amount ~= nil, "Failed to parse line: " .. line)

        local ticks
        value, ticks = dial:spin(value, amount, line:sub(1, 1))
        if value == 0 then
            exacts = exacts + 1
        end

        passed = passed + ticks
    end
    return exacts, passed
end

--- The main run function for day 1.
function day1:run(infile)
    local part1, part2 = day1:count_zeros(io.lines(infile))
    print("Part 1: " .. part1)
    print("Part 2: " .. part2)
end

return day1
