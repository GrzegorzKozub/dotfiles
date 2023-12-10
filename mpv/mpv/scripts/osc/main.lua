-- https://github.com/mpv-player/mpv/blob/master/DOCS/man/lua.rst
-- https://aegisub.org/docs/latest/ass_tags/

-- luacheck: ignore 113

mp.commandv('set', 'osc', 'no')

local elements = require 'elements'
local mouse = require 'mouse'
local osd = require 'osd'
local window = require 'window'

local shown = false

elements.init()

mp.observe_property('osd-dimensions', 'native', function()
  window.update()
  osd.setup()
  elements.refresh()
  if shown then
    elements.redraw()
  end
end)

mouse.on_move(function()
  elements.redraw()
  require('timer').delay(3, function()
    osd.update ''
    shown = false
  end)
  shown = true
end)

-- bug: when (un)pausing, the osc shows up and does not hide
