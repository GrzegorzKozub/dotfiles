local M = {}
local draw = require 'draw'
local format = require 'format'

function M.background(window)
  local fmt = {
    position = { x = 0, y = window.height(), align = 7 },
    color = { '000000', '000000', '000000', '000000' },
    alpha = { 0, 0, 0, 0 },
    border = 128,
    blur = 128,
    font = { name = '', size = 0 },
  }
  return format.tag(fmt) .. draw.box(window.width(), 1)
end

function M.play(window)
  local fmt = {
    position = { x = window.width() / 2, y = window.height() - 64, align = 5 },
    color = { 'ffffff', '000000', '000000', '000000' },
    alpha = { 32, 0, 0, 0 },
    border = 0,
    blur = 1,
    font = { name = 'monospace', size = 64 },
  }
  return format.tag(fmt) .. '󰐊'
end

function M.next(window)
  local fmt = {
    position = { x = window.width() / 2 + 64, y = window.height() - 64, align = 5 },
    color = { 'ffffff', '000000', '000000', '000000' },
    alpha = { 32, 0, 0, 0 },
    border = 0,
    blur = 1,
    font = { name = 'monospace', size = 64 },
  }
  return format.tag(fmt) .. '󰒭'
end

return M
