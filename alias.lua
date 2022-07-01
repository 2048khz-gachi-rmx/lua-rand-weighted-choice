local gen


function gen()
	local wbase = require("wrand") ()

	function wbase.ConvertInput(tbl)
		local cache = wbase.CacheTable
		local cc = cache[tbl]

		if wbase.ENABLE_CACHING and cc then
			return cc
		end

		local out = {
			{}, -- probability table
			{}, -- alias table
			{}, -- array of entries (for O(1) choice)
		}

		local prob, alias = out[1], out[2]
		local arr, arrLen = out[3], 0

		local overfull, underfull = {}, {} -- probability is >= 1 & less than 1, respectively
		local oLen, uLen = 0, 0

		local inLen = 0

		-- hafta count the table length for this... blegh
		for k,v in pairs(tbl) do
			inLen = inLen + 1
		end

		for k,v in pairs(tbl) do
			local weight = v * inLen
			prob[k] = weight

			if weight < 1 then
				uLen = uLen + 1
				underfull[uLen] = k
			else
				oLen = oLen + 1
				overfull[oLen] = k
			end

			arrLen = arrLen + 1
			arr[arrLen] = k
		end

		-- https://en.wikipedia.org/wiki/Alias_method

		while oLen > 0 and uLen > 0 do
			-- i dont respect table.insert/table.remove

			-- 1. Arbitrarily choose an overfull entry Ui > 1 and an underfull entry Uj < 1
			local o, u = overfull[oLen], underfull[uLen]

			-- 2. Set Alias[j] = i
			alias[u] = o

			-- 3. Remove the allocated space from probability Ui by changing Ui += Uj − 1

			local newProb = prob[o] + prob[u] - 1
			prob[o] = newProb

			-- 4. Assign `i` to the appropriate category based on Ui
			if newProb < 1 then
				underfull[uLen] = o -- replace top in underfull with the entry from overfull
				oLen = oLen - 1 	-- then shrink overfull
			else
				underfull[uLen] = nil -- shrink underfull without shrinking overfull
				uLen = uLen - 1
			end
		end

		for i=oLen, 1, -1 do
			prob[overfull[i]] = 1
		end

		for i=uLen, 1, -1 do
			prob[underfull[i]] = 1
		end

		if wbase.ENABLE_CACHING then
			cache[tbl] = out
		end

		return out
	end

	local conv = wbase.ConvertInput
	local random = math.random

	function wbase.Select(tbl)
		local dat = conv(tbl)
		local prob, alias, arr = dat[1], dat[2], dat[3]

		local choice = arr[random(#arr)]

		if prob[choice] >= random() then
			return choice
		else
			return alias[choice]
		end
	end

	function wbase.SelectTable(tbl, num, into)
		local out = into or {}

		num = num or 1

		local dat = conv(tbl)
		local prob, alias, arr = dat[1], dat[2], dat[3]

		for i=1, num do
			local choice = arr[random(#arr)]

			if prob[choice] >= random() then
				out[i] = choice
			else
				out[i] = alias[choice]
			end
		end

		return out
	end

	return wbase
end

return gen