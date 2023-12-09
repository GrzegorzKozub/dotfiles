local M = {}

local size = { width = 0, height = 0 }

function M.get_size()
  return size
end

function M.set_size()
  -- size.width, size.height = mp.get_osd_size()
  size.width, size.height = 400, 400
end

return M
