local M = {}

function M.get()
  return {
    background = {
      type = 'box',
      layer = 1,
      position = { x = 10, y = 10, align = 7 },
      size = { width = 200, height = 100 },
      color = { '00ff00', '000000', '000000', '000000' },
      alpha = { 0, 0, 0, 0 },
      border = { size = 0, blur = 0, shadow = 0, radius = 0 },
      font = { name = '', size = 0, wrap = 2 },
    },
    test = {
      type = '',
      text = 'test',
      layer = 2,
      position = { x = 800, y = 800, align = 7 },
      size = { width = 100, height = 100 },
      color = { 'ff0000', '000000', '000000', '000000' },
      alpha = { 0, 0, 0, 0 },
      border = { size = 0, blur = 0, shadow = 0, radius = 0 },
      font = { name = 'monospace', size = 80, wrap = 2 },
    },
  }
end

return M
