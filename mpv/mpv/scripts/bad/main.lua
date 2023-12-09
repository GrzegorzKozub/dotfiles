mp.commandv("set", "osc", "no")
local ex = require("element")
local osd = mp.create_osd_overlay("ass-events")

local function setOsd(text)
  if text == osd.data then
    return
  end
  osd.data = text
  osd:update()
end


local window = require('window')
local elements = require('elements').get(window)
window.set_size()
mp.observe_property('osd-dimensions', 'native',
	function(name, val)
		window.set_size()
setOsd(ex.render(elements.background()) .. '\n' .. ex.render(elements.test)  )
  end)

setOsd(ex.render(elements.background()) .. '\n' .. ex.render(elements.test)  )
