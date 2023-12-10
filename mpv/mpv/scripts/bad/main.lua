-- https://github.com/mpv-player/mpv/blob/master/DOCS/man/lua.rst

-- luacheck: ignore 113

mp.commandv('set', 'osc', 'no')

local elements = require 'elements'
local mouse = require 'mouse'
local osd = require 'osd'
local window = require 'window'

local shown = false

elements.init(window, osd, mouse)

mp.observe_property('osd-dimensions', 'native', function()
  window.update()
  osd.setup(window)
  elements.refresh(window)
  if shown then
    osd.update(elements.osd())
  end
end)

mouse.on_move(function()
  osd.update(elements.osd())
  require('timer').delay(3, function()
    osd.update ''
    shown = false
  end)
  shown = true
end)

