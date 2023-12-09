local M = {}

function M.get(window)
  return {
    background = function()
      return {
        type = 'box',
        layer = 5,
        position = { x = window.get_size().width / 2, y = window.get_size().height / 2, align = 7 },
        size = { width = 200, height = 100 },
        color = { '00ff00', '000000', '000000', '000000' },
        alpha = { 0, 0, 0, 0 },
        border = { size = 0, blur = 0, shadow = 0, radius = 0 },
        font = { name = '', size = 0, wrap = 2 },
      }
    end,
    test = {
      type = '',
      text = 'test',
      layer = 10,
      position = { x = 150, y = 30, align = 7 },
      size = { width = 100, height = 100 },
      color = { 'ff0000', '000000', '000000', '000000' },
      alpha = { 0, 0, 0, 0 },
      border = { size = 0, blur = 0, shadow = 0, radius = 0 },
      font = { name = 'monospace', size = 80, wrap = 2 },
    },
  }
end

return M
