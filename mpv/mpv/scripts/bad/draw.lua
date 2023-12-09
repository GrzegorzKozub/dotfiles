local assdraw = require 'mp.assdraw'
local M = {}

function M.box(width, height)
  local ass = assdraw.ass_new()
  ass:new_event()
  ass:draw_start()
  ass:round_rect_cw(0, 0, width, height, 0, 0)
  ass:draw_stop()
  return ass.text
end

return M
