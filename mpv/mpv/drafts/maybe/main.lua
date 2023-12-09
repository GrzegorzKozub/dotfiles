-- https://github.com/maoiscat/mpv-osc-framework
-- luacheck: ignore 111 112 113 212

require("expansion")
require("oscf")

opts = {
  scale = 2,
  hideTimeout = 1,
  fadeDuration = 0.5,
}

local env = newElement("env", require('elements').get().background)
env.layer = 1000
env.visible = false
env.responder = {}
env.responder["resize"] = function(self)
  player.geo.refX = player.geo.width / 2
  player.geo.refY = player.geo.height - 40
  setActiveArea("background", 0, player.geo.height - 120, player.geo.width, player.geo.height)
end
require('element').init(env)
addToPlayLayout("env")

local background = newElement("background", require('elements').get().background)
background.responder = {}
background.responder["resize"] = function(self)
  self.geo.x = player.geo.refX
  self.geo.y = player.geo.height
  self.geo.w = player.geo.width
  require('element').position(self)
  require('element').render(self)
end
require('element').init(background)
addToPlayLayout("background")
