local wrand = require("../wrand.lua") ()

local ExampleTable = {
	thing = 0.5,
	equal_thing = 0.5,

	better_thing = 1,
	never_pick_me = 0,
}

print("randomly picked:", wrand.Select(ExampleTable))


local counters = {}

local function resetCounters()
	for k,v in pairs(ExampleTable) do
		counters[k] = 0
	end
end

resetCounters()

local n = 1000000
for i=1, n do
	local pick = wrand.Select(ExampleTable)
	counters[pick] = counters[pick] + 1
end

print("distribution over " .. n .. " samples:")
for k,v in pairs(counters) do
	local fmt = ("	%s: %.1f%%"):format(k, v / n * 100)
	print(fmt)
end