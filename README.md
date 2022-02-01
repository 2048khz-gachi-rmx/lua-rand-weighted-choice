# Usage
Basic example:
```lua
local wrand = require("wrand.lua") () -- requiring the file returns a generator for the library

local ExampleTable = {
  SomeChoice = 25, -- 25/100 weight; will be picked 25% of the time
  EqualChoice = 25, -- 25/100 weight; will be picked 25% of the time
  
  BetterChoice = 50, -- 50/100 weight; will be picked 50% of the time
  NeverPicked = 0, -- will never be picked
}

-- returns a random key, either "SomeChoice", "EqualChoice" or "BetterChoice"
local randKey = wrand.Select(ExampleTable)

-- returns a table with 100 random keys ( { "SomeChoice", "BetterChoice", "SomeChoice", ... } )
local randKeys = wrand.SelectTable(ExampleTable, 100)
```

## More examples can be found [here](https://github.com/2048khz-gachi-rmx/lua-rand-weighted-choice/tree/main/examples)

### Caching
```lua
-- wrand uses caching internally; if you modify the input table, you need to reset the cache

ExampleTable.BetterChoice = 0 -- "BetterChoice" cannot be picked anymore
wrand.InvalidateCache(ExampleTable)

-- alternatively, you can disable cache entirely, however,
-- be aware that this will drastically reduce performance for repeated selections
wrand.ENABLE_CACHING = false
```

### Custom Input
wrand can be modified to accept custom input by overriding the `wrand.ConvertInput(tbl)` function.  
See [custom_format.lua](https://github.com/2048khz-gachi-rmx/lua-rand-weighted-choice/blob/main/examples/custom_format.lua) for an example.
