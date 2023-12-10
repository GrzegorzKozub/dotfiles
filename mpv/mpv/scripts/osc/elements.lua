-- luacheck: ignore 113

local M = {}

local draw = require 'draw'
local hitbox = require 'hitbox'
local mouse = require 'mouse'
local osd = require 'osd'
local tags = require 'tags'
local window = require 'window'

local elements = {}

local function background()
  local data = function()
    return {
      geo = { x = 0, y = window.height(), width = window.width(), height = 1, align = 7 },
      color = { '000000', '000000', '000000', '000000' },
      alpha = { 0, 0, 0, 0 },
      border = 128,
      blur = 128,
      font = { name = '', size = 0 },
    }
  end
  return {
    data = data(),
    refresh = function(self)
      self.data = data()
    end,
    osd = function(self)
      return tags.get(self.data) .. draw.box(self.data.geo.width, self.data.geo.height)
    end,
    hitbox = function(self)
      return hitbox.get(self.data.geo)
    end,
    handlers = {},
  }
end

local function play_pause()
  local data = function()
    return {
      geo = { x = window.width() / 2, y = window.height() - 64, width = 32, height = 32, align = 5 },
      color = { 'ffffff', '000000', '000000', '000000' },
      alpha = { 32, 0, 0, 0 },
      border = 0,
      blur = 0,
      font = { name = 'monospace', size = 64 },
      text = mp.get_property_bool 'pause' and '󰐊' or '󰏤',
    }
  end
  return {
    data = data(),
    refresh = function(self)
      self.data = data()
    end,
    osd = function(self)
      return tags.get(self.data) .. self.data.text
    end,
    hitbox = function(self)
      return hitbox.get(self.data.geo)
    end,
    handlers = {
      mbtn_left_up = function(self, arg)
        -- todo: hitbox
        print(arg.x, arg.y)
        mp.commandv('cycle', 'pause')
      end,
    },
  }
end

function M.init()
  elements = { background(), play_pause() }
  mp.observe_property('pause', 'bool', function()
    elements[2]:refresh()
    M.redraw()
  end)
  for _, event in ipairs { 'mbtn_left_up' } do
    for _, element in ipairs(elements) do
      if element.handlers[event] then
        mouse.subscribe(event, function(arg)
          element.handlers[event](element, arg)
        end)
      end
    end
  end
end

function M.refresh()
  for _, element in ipairs(elements) do
    if element.refresh then
      element:refresh()
    end
  end
end

function M.redraw()
  osd.update(elements[1]:osd() .. '\n' .. elements[2]:osd() .. '\n')
end

return M
