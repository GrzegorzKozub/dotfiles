mp.commandv("set", "osc", "no")
local ex = require("element")
local osd = mp.create_osd_overlay("ass-events")
local elements = require('elements').get()

local function setOsd(text)
  if text == osd.data then
    return
  end
  osd.data = text
  osd:update()
end


setOsd(ex.render(elements.background) .. ex.render(elements.test)  )
