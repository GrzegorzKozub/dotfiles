function Status:mode()
  local mode = tostring(cx.active.mode):upper()
  if mode == 'UNSET' then
    mode = 'u'
  end

  if mode == 'NORMAL' then
    mode = 'n'
  end

  if mode == 'SELECT' then
    mode = 's'
  end
  local style = self.style()
  return ui.Line {
    ui.Span(' ' .. mode .. ' '):style(style),
  }
end

function Status:size()
  local h = cx.active.current.hovered
  if not h then
    return ui.Line {}
  end

  return ui.Line {
    ui.Span(' ' .. ya.readable_size(h:size() or h.cha.length) .. ' ')
      :fg(THEME.status.separator_style.fg)
      :bg(THEME.status.separator_style.bg),
  }
end

function Status:name()
  local h = cx.active.current.hovered
  if not h then
    return ui.Span ''
  end
  local linked = ''
  if h.link_to ~= nil then
    linked = ' -> ' .. tostring(h.link_to)
  end
  return ui.Span(' ' .. h.name .. linked):fg(THEME.status.separator_style.bg)
end

function Status:owner()
  local h = cx.active.current.hovered
  if h == nil or ya.target_family() ~= 'unix' then
    return ui.Line {}
  end
  return ui.Line {
    ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg(THEME.status.separator_style.bg),
    ui.Span ' ',
    ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg(THEME.status.separator_style.bg),
    ui.Span ' ',
  }
end

function Status:permissions()
  local h = cx.active.current.hovered
  if not h then
    return ui.Line {}
  end

  local perm = h.cha:permissions()
  if not perm then
    return ui.Line {}
  end

  local spans = {}
  for i = 1, #perm do
    local c = perm:sub(i, i)
    local style = THEME.status.permissions_t
    if c == '-' then
      style = THEME.status.permissions_s
    elseif c == 'r' then
      style = THEME.status.permissions_r
    elseif c == 'w' then
      style = THEME.status.permissions_w
    elseif c == 'x' or c == 's' or c == 'S' or c == 't' or c == 'T' then
      style = THEME.status.permissions_x
    end
    spans[i] = ui.Span(c):style(style)
  end
  table.insert(spans, 1, ui.Span ' ':bg(THEME.status.separator_style.bg))
  table.insert(spans, ui.Span ' ':bg(THEME.status.separator_style.bg))
  return ui.Line(spans)
end

function Status:percentage_and_position()
  local percent = 0
  local cursor = cx.active.current.cursor
  local length = #cx.active.current.files
  if cursor ~= 0 and length ~= 0 then
    percent = math.floor((cursor + 1) * 100 / length)
  end

  return ui.Line {
    -- ui.Span(percent):style(THEME.status.mode_normal),
    ui.Span(string.format(' %d%% %d/%d ', percent, cursor + 1, length)):style(THEME.status.mode_normal),
  }
end

function Status:render(area)
  self.area = area
  local left = ui.Line { self:mode(), self:size(), self:name() }
  local right = ui.Line { self:owner(), self:permissions(), self:percentage_and_position() }
  return {
    ui.Paragraph(area, { left }),
    ui.Paragraph(area, { right }):align(ui.Paragraph.RIGHT),
    table.unpack(Progress:render(area, right:width())),
  }
end

-- function File:found(file)
--   if not file:is_hovered() then
--     return {}
--   end
--
--   local found = file:found()
--   if not found then
--     return {}
--   end
--
--   return {
--     ui.Span ' ',
--     ui.Span(string.format('%d/%d', found[1] + 1, found[2])):style(THEME.manager.find_position),
--   }
-- end
