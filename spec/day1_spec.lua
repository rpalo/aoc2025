local day1 = require("days.day1")
local dial = day1.dial

function assertSpin(initial, amount, direction, result, ticks)
    local v, t = dial:spin(initial, amount, direction)
    assert.is.equal(v, result)
    assert.is.equal(t, ticks)
end

describe("Day 1", function()
    describe("spin", function()
        it("should return directly if it's in range", function()
            assertSpin(50, 3, "R", 53, 0)
        end)

        it("Should clamp negative", function()
            assertSpin(50, 53, "L", 97, 1)
        end)

        it("Should clamp positive", function()
            assertSpin(50, 53, "R", 3, 1)
        end)

        it("doesn't need to clamp 0", function()
            assertSpin(50, 50, "L", 0, 1)
        end)

        it("Does clamp on 100 (back to zero)", function()
            assertSpin(50, 50, "R", 0, 1)
        end)

        it("Doesn't tick off zero", function()
            assertSpin(0, 5, "R", 5, 0)
            assertSpin(0, 5, "L", 95, 0)
        end)
    end)

    describe("count_zeros", function()
        it("should succeed on the test case", function()
            local part1, part2 = day1:count_zeros(io.lines("data/day1_test.txt"))
            assert.is.equal(3, part1)
            assert.is.equal(6, part2)
        end)
    end)
end)
