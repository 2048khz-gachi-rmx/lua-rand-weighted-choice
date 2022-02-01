local wrand = require("../wrand.lua") ()

local ExampleTable = {
	thing = 0.5,
	equal_thing = 0.5,

	better_thing = 1,
	never_pick_me = 0,
}

local picks = wrand.SelectTable(ExampleTable, 500) -- select 500 keys

local counters = {}

local function resetCounters()
	for k,v in pairs(ExampleTable) do
		counters[k] = 0
	end
end

resetCounters()

local function printCounters(amt)
	print("distribution over " .. amt .. " samples:")
	for k,v in pairs(counters) do
		local fmt = ("	%s: %.1f%%"):format(k, v / amt * 100)
		print(fmt)
	end
end

for k,v in pairs(picks) do
	counters[v] = counters[v] + 1
end

printCounters(#picks)

resetCounters()

-- you can also reuse an existing table for results - the first N keys will be filled
-- this is the most optimized way for picking a lot of results
local reuse = {}
local step = 8192
local n = 1000000

for i=1, n, step do
	wrand.SelectTable(ExampleTable, step, reuse)

	for k,v in pairs(reuse) do
		counters[v] = counters[v] + 1
	end
end

printCounters(n)