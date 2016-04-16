rc_switch = {}

local pin
local plen
local rep

local cmd_strings = {
  { on = "FFF0FFFF0101", off = "FFF0FFFF0110" },
  { on = "FFF0FFFF1001", off = "FFF0FFFF1010" },
  { on = "FFF0FFFF0001", off = "FFF0FFFF0010" },
  { on = "FFF0FF1F0001", off = "FFF0FF1F0010" },
  { on = "FFF0F1FF0001", off = "FFF0F1FF0010" },
}

--[[ "zero" bit:
    _     _
   | |___| |___

--]]
local append_zero = function(tab, pl)
  local i
  for i = 1,2 do
    table.insert(tab, pl)
    table.insert(tab, pl * 3)
  end
end

--[[ "one" bit:
    ___   ___
   |   |_|   |_

--]]
local append_one = function(tab, pl)
  local i
  for i = 1,2 do
    table.insert(tab, pl * 3)
    table.insert(tab, pl)
  end
end

--[[ "F" bit:
    _     ___
   | |___|   |_

--]]
local append_f = function(tab, pl)
  table.insert(tab, pl)
  table.insert(tab, pl * 3)
  table.insert(tab, pl * 3)
  table.insert(tab, pl)
end

--[[ sync:
    _
   | |__ ... one pulse HIGH, then LOW 31 * pulse_length

--]]
local append_sync = function(tab, pl)
  table.insert(tab, pl)
  table.insert(tab, pl * 31)
end

local transitions = function(cmd, pl)
  local result = {}
  local len = #cmd
  local i, k
  for i = 1,len do
    local k = cmd:sub(i,i)
    if k == '0' then
      append_zero(result, pl)
    elseif k == '1' then
      append_one(result, pl)
    elseif k == 'F' then
      append_f(result, pl)
    end
  end
  append_sync(result, pl)
  return result
end

-- Params:
-- p: pin number
-- l: pulse length
-- r: send frame this number of times
rc_switch.init = function(p, l, r)
  pin = p or 3
  plen = l or 160
  rep = r or 3
  gpio.mode(pin, gpio.OUTPUT, gpio.PULLUP)
end

rc_switch.switch = function(button, position)
  local s = transitions(cmd_strings[button][position], plen)
  gpio.serout(pin, 1, s, rep)
end

return rc_switch

