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

-- alias

local n = 10000000
local now3 = uv.now()

for i=1, n do
	local pick = wrand.Select(ExampleTable)
	counters[pick] = counters[pick] + 1
end

uv.update_time()
local now4 = uv.now()

print("ALIAS:", now4 - now3, "distribution over " .. n .. " samples:")
for k,v in pairs(counters) do
	local fmt = ("	%s: %.1f%%"):format(k, v / n * 100)
	print(fmt)

	counters[k] = 0
end

-- bsearch

uv.update_time()
local now1 = uv.now()

for i=1, n do
	local pick = arand.Select(ExampleTable)
	counters[pick] = counters[pick] + 1
end

uv.update_time()
local now2 = uv.now()

print("BSEARCH:", now2 - now1, "distribution over " .. n .. " samples:")
for k,v in pairs(counters) do
	local fmt = ("	%s: %.1f%%"):format(k, v / n * 100)
	print(fmt)
end

resetCounters()