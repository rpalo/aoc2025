rockspec_format = "3.0"
package = "aoc2025"
version = "dev-1"
source = {
    url = "https://github.com/rpalo/aoc2025"
}
description = {
    summary = "Ryan's Advent of Code 2025 solutions",
    homepage = "https://github.com/rpalo/aoc2025",
    license = "None"
}
dependencies = {
    "lua ~> 5.4"
}
test_dependencies = {
    "busted"
}
test = {
    type = "busted",
    flags = { "spec" }
}
-- dev_dependencies = {
--     "template",
-- }
build = {
    type = "builtin",
    modules = {}
}
