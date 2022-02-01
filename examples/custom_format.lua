-- we'll be overriding the default behaviour, so we need a new envinroment
local wrand = require("../wrand.lua") ()

-- pick random words from a string
-- note that there are repeated words in this text

-- http://lua-users.org/wiki/MathLibraryTutorial @ math.random
local Text = [[
If Lua could get milliseconds from os.time() the init could be better done.
Another thing to be aware of is truncation of the seed provided.
math.randomseed will call the underlying C function srand which takes an unsigned integer value.
Lua will cast the value of the seed to this format.
In case of an overflow the seed will actually become a bad seed, without warning (note that Lua 5.1 actually casts to a signed int, which was corrected in 5.2).
Nevertheless, in some cases we need a controlled sequence, like the obtained with a known seed.
But beware! The first random number you get is not really 'randomized' (at least in Windows 2K and OS X).
To get better pseudo-random number just pop some random number before using them for real:
]]

local cachedData, cachedSum

local counters = {}

function wrand.ConvertInput(str)
	-- doing this each time would get expensive;
	-- cache the result once and reuse it
	if cachedData then return cachedData, cachedSum end

	local vals, sums = {}, {}
	local sum = 0

	for word in Text:gmatch("%w+") do
		word = word:lower()
		if not counters[word] then -- there are repeated words in the text
			sum = sum + #word
			table.insert(vals, word)
			table.insert(sums, sum) -- longer words have more weight; repeats don't

			counters[word] = 0
		end
	end

	cachedData = {vals, sums}
	cachedSum = sum

	return cachedData, sum
end

local n = 1000000
for i=1, n do
	local pick = wrand.Select(Text)
	counters[pick] = counters[pick] + 1
end

local sortedCounters = {}
for k,v in pairs(counters) do
	sortedCounters[#sortedCounters + 1] = {k, v}
end
table.sort(sortedCounters, function(a, b) return a[2] > b[2] end)

-- count the length of unique words in this text
local gotWords = {}
local charCount = 0

Text:gsub("%w+", function(w)
	w = w:lower()
	if not gotWords[w] then
		charCount = charCount + #w
	end
	gotWords[w] = true
end)


print("distribution over " .. n .. " samples:")
for k,v in ipairs(sortedCounters) do
	local fmt = ("	%s: %.2f%% (desired: %.2f%%)"):format(
		v[1],
		v[2] / n * 100,
		#v[1] / charCount * 100
	)

	print(fmt)
end
