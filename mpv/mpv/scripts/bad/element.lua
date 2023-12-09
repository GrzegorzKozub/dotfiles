local M = {}

local assdraw = require 'mp.assdraw'

function M.render(el)
  local a = {
    '{',
    string.format('\\pos(%f,%f)\\an%d', el.position.x, el.position.y, el.position.align),
    '}',
    '{',
    string.format('\\1a&H%x&\\2a&H%x&\\3a&H%x&\\4a&H%x&', el.alpha[1], el.alpha[2], el.alpha[3], el.alpha[4]),
    string.format('\\1c&H%s&\\2c&H%s&\\3c&H%s&\\4c&H%s&', el.color[1], el.color[2], el.color[3], el.color[4]),
    string.format('\\bord%.2f', el.border.size),
    '\\fn' .. el.font.name,
    string.format('\\fs%.2f', el.font.size),
    '}',
  }

  local b = table.concat(a)

  if el.type == 'box' then
    local ass = assdraw.ass_new()
    ass:new_event()
    ass:draw_start()
    ass:round_rect_cw(0, 0, el.size.width, el.size.height, el.border.radius, el.border.radius)

    ass:draw_stop()
    b = b .. ass.text
  else
    b = b .. el.text
  end
  return b
end

return M
