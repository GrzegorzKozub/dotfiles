local M = {}

function M.init(el)
  M.position(el)
  M.style(el)
  M.render(el)
end

function M.position(el)
  if not el.geo then
    return
  end
  el.pack[1] = string.format("{\\pos(%f,%f)\\an%d}", el.geo.x, el.geo.y, el.geo.an)
end

function M.alpha(el, trans)
  local sta = el.style.alpha
  local alpha = { 0, 0, 0, 0 }
  el.trans = trans
  for i = 1, 4 do
    alpha[i] = 255 - (255 - sta[i]) * (1 - trans)
  end
  el.pack[2] = string.format("{\\1a&H%x&\\2a&H%x&\\3a&H%x&\\4a&H%x&}", alpha[1], alpha[2], alpha[3], alpha[4])
end

function M.style(el)
  local st = el.style
  local fmt = { "{", "", "", "", "", "", "", "", "}" }
  fmt[2] = string.format("\\1c&H%s&\\2c&H%s&\\3c&H%s&\\4c&H%s&", st.color[1], st.color[2], st.color[3], st.color[4])
  fmt[3] = string.format("\\bord%.2f", st.border)
  fmt[4] = string.format("\\blur%.2f", st.blur)
  fmt[5] = string.format("\\shad%.2f", st.shadow)
  fmt[6] = "\\fn" .. st.font
  fmt[7] = string.format("\\fs%.2f", st.fontsize)
  fmt[8] = string.format("\\q%d", st.wrap)
  el.pack[3] = table.concat(fmt)
  M.alpha(el, el.trans)
end

function M.render(el) end

function M.tick(el)
  if el.visible then
    return table.concat(el.pack)
  else
    return ""
  end
end

return M
