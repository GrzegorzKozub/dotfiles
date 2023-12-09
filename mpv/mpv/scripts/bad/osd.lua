-- luacheck: ignore 113

local M = {}

local osd = mp.create_osd_overlay 'ass-events'

function M.setup(window)
  osd.res_x = window.width()
  osd.res_y = window.height()
end

function M.update(data)
  if data == osd.data then
    return
  end
  osd.data = data
  osd:update()
end

return M
