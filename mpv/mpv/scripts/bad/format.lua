-- https://aegisub.org/docs/latest/ass_tags/

local M = {}

function M.tag(format)
  local tags = '{'
  tags = tags .. string.format('\\pos(%f,%f)\\an%d', format.position.x, format.position.y, format.position.align)
  if format.color then
    tags = tags
      .. string.format(
        '\\1c&H%s&\\2c&H%s&\\3c&H%s&\\4c&H%s&',
        format.color[1],
        format.color[2],
        format.color[3],
        format.color[4]
      )
  end
  if format.alpha then
    tags = tags
      .. string.format(
        '\\1a&H%x&\\2a&H%x&\\3a&H%x&\\4a&H%x&',
        format.alpha[1],
        format.alpha[2],
        format.alpha[3],
        format.alpha[4]
      )
  end
  if format.border then
    tags = tags .. string.format('\\bord%.2f', format.border)
  end
  if format.blur then
    tags = tags .. string.format('\\blur%.2f', format.blur)
  end
  if format.font then
    tags = tags .. '\\fn' .. format.font.name .. string.format('\\fs%.2f', format.font.size)
  end
  tags = tags .. '}'
  return tags
end

return M
