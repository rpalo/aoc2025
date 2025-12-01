local usage = string.format([[
USAGE: %s [-h|--help] [-t|--test] [-d|--day N]
    -h/--help: print this help
    -t/--test: Use data files ending in _test.txt instead of .txt
    -d/--day N: Only run specifically Day N and exit
]], arg[0])

local finished_days = {
    ["1"] = true,
}

local start = os.clock()
local suffix = ".txt"

local function run_single_day(i)
    print(string.format("=== Day %d ===", i))
    require("days.day" .. i):run("data/day" .. i .. suffix)
    print(string.format("= Time: %.6f =", os.clock() - start))
end

for i, opt in ipairs(arg) do
    if opt == "--test" or opt == "-t" then
        suffix = "_test.txt"
    end

    if opt == "--help" or opt == "-h" then
        print(usage)
        return
    end

    if opt == "--day" or opt == "-d" then
        local day = arg[i + 1]
        if not finished_days[day] then
            print("Day " .. day .. " isn't done yet.")
            os.exit(1)
        end
        run_single_day(day)
        return
    end
end

print "===== Advent of Code 2025 ====="
for day, _ in pairs(finished_days) do
    run_single_day(day)
end
