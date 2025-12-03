local day2 = require('days.day2')

describe("Day 2", function()
  describe("parse", function()
    it("parses as expected", function()
      local input = "11-22,33-44,55-6666"
      assert.are.same(
        day2:parse(input),
        {
          { start = 11, finish = 22 },
          { start = 33, finish = 44 },
          { start = 55, finish = 6666 },
        }
      )
    end)
  end)

  describe("Part 1", function()
    it("Solves the test case", function()
      local contents = day2:load("data/day2_test.txt")
      local data = day2:parse(contents)
      local result = day2:part1(data)
      assert.is.equal(result, 1227775554)
    end)
  end)

  describe("Part 2", function()
    it("Solves the test case", function()
      local contents = day2:load("data/day2_test.txt")
      local data = day2:parse(contents)
      local result = day2:part2(data)
      assert.is.equal(result, 4174379265)
    end)

    it("Dedupes the numbers", function()
      local ranges = {
        day2.Range.new(1000, 1090),
        day2.Range.new(1000, 1090),
      }
      local result = day2:part2(ranges)
      assert.is.equal(result, 1010)
    end)
  end)
end)
