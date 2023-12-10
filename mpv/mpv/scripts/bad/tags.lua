-- https://aegisub.org/docs/latest/ass_tags/

local M = {}

function M.get(data)
  local tags = '{'
  tags = tags .. string.format('\\pos(%f,%f)\\an%d', data.geo.x, data.geo.y, data.geo.align)
  if data.color then
    tags = tags
      .. string.format(
        '\\1c&H%s&\\2c&H%s&\\3c&H%s&\\4c&H%s&',
        data.color[1],
        data.color[2],
        data.color[3],
        data.color[4]
      )
  end
  if data.alpha then
    tags = tags
      .. string.format(
        '\\1a&H%x&\\2a&H%x&\\3a&H%x&\\4a&H%x&',
        data.alpha[1],
        data.alpha[2],
        data.alpha[3],
        data.alpha[4]
      )
  end
  if data.border then
    tags = tags .. string.format('\\bord%.2f', data.border)
  end
  if data.blur then
    tags = tags .. string.format('\\blur%.2f', data.blur)
  end
  if data.font then
    tags = tags .. '\\fn' .. data.font.name .. string.format('\\fs%.2f', data.font.size)
  end
  tags = tags .. '}'
  return tags
end

return M
