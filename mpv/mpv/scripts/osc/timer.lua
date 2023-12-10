-- luacheck: ignore 113

local M = {}

local delay = 0
local elapsed = 0
local callback = nil
local timer = nil

local function reset()
  if timer then
    timer:kill()
    elapsed = 0
  end
end

local function tick()
  elapsed = elapsed + 1
  if elapsed >= delay then
    if callback then
      callback()
    end
    reset()
  end
end

function M.delay(seconds, action)
  reset()
  delay = seconds
  callback = action
  timer = mp.add_periodic_timer(1, tick)
end

return M
