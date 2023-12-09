local M = {}

function M.get()
  return {
    background = {
      layer = 10,
      geo = { x = 100, y = 100, w = 4000, h = 300, an = 7 },
      trans = 0,
      style = {
        color = { "0", "0", "0", "0" },
        alpha = { 255, 255, 0, 0 },
        border = 150,
        blur = 150,
        shadow = 0,
        font = "",
        fontsize = 10,
        wrap = 2,
      },
      visible = true,
      pack = { "", "", "", "" },
      responser = {}
    },
  }
end

return M
