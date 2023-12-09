-- luacheck: ignore 113

mp.commandv('set', 'osc', 'no')

local elements = require 'elements'
local osd = require 'osd'
local window = require 'window'

window.update()
osd.setup(window)

mp.observe_property('osd-dimensions', 'native', function()
  window.update()
  osd.setup(window)
end)

osd.update(elements.background(window) .. '\n' .. elements.play(window) .. '\n' .. elements.next(window))
