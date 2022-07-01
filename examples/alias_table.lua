local arand = require("../alias.lua") ()
local wrand = require("../wrand.lua") ()
local uv = require("uv")

local ExampleTable = {
	thing = 0.5,
	equal_thing = 0.5,

	better_thing = 1,
	never_pick_me = 0,
}

local counters = {}

local function resetCounters()
	for k,v in pairs(ExampleTable) do
		counters[k] = 0
	end
end

resetCounters()

local function printCounters(amt, t)
	print(t, "distribution over " .. amt .. " samples:")
	for k,v in pairs(counters) do
		local fmt = ("	%s: %.1f%%"):format(k, v / amt * 100)
		print(fmt)
	end
end

resetCounters()

-- you can also reuse an existing table for results - the first N keys will be filled
-- this is the most optimized way for picking a lot of results
local reuse = {}
local step = 8192
local n = 10000000

local now1 = uv.now()

for i=1, n, step do
	wrand.SelectTable(ExampleTable, step, reuse)

	for k,v in pairs(reuse) do
		counters[v] = counters[v] + 1
	end
end

uv.update_time()
local now2 = uv.now()

printCounters(n, "BSEARCH: " .. (now2 - now1))
resetCounters()

local now3 = uv.now()

for i=1, n, step do
	arand.SelectTable(ExampleTable, step, reuse)

	for k,v in pairs(reuse) do
		counters[v] = counters[v] + 1
	end
end

uv.update_time()
local now4 = uv.now()

printCounters(n, "ALIAS: " .. (now4 - now3))