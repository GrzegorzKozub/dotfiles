-- luacheck: ignore 113

local M = {}

local size = { width = 0, height = 0 }

function M.width()
  return size.width
end

function M.height()
  return size.height
end

function M.update()
  local width, height, aspect = mp.get_osd_size()
  if aspect > 0 then
    size.width, size.height = width, height
  else
    size.width, size.height = 1280, 720
  end
end

return M
