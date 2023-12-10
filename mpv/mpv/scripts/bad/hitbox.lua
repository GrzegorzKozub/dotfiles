local M = {}

local function calculate(x, y, w, h, al)
  local aligns = {
    [1] = function()
      return x, y - h, x + w, y
    end,
    [2] = function()
      return x - (w / 2), y - h, x + (w / 2), y
    end,
    [3] = function()
      return x - w, y - h, x, y
    end,
    [4] = function()
      return x, y - (h / 2), x + w, y + (h / 2)
    end,
    [5] = function()
      return x - (w / 2), y - (h / 2), x + (w / 2), y + (h / 2)
    end,
    [6] = function()
      return x - w, y - (h / 2), x, y + (h / 2)
    end,
    [7] = function()
      return x, y, x + w, y + h
    end,
    [8] = function()
      return x - (w / 2), y, x + (w / 2), y + h
    end,
    [9] = function()
      return x - w, y, x, y + h
    end,
  }
  return aligns[al]()
end

function M.get(geo)
  return calculate(geo.x, geo.y, geo.width, geo.height, geo.align)
end

return M
