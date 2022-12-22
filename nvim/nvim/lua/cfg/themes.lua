local M = {}

local function normalize_colors(wanted)
  local allowed = { solarized = "solarized8", gruvbox = "gruvbox8_soft" }
  return allowed[wanted] ~= nil and allowed[wanted] or "gruvbox8_soft"
end

local function normalize_background(wanted)
  for _, v in ipairs({ "dark", "light" }) do
    if wanted == v then
      return wanted
    end
  end
  return "dark"
end

local function theme()
  local _, _, colors, background = string.find(vim.env.MY_THEME or "", "([%a%d]+)%-([%a%d]+)")
  return normalize_colors(colors), normalize_background(background)
end

function M.init()
  local colors, background = theme()
  vim.opt.background = background
  vim.cmd.colorscheme(colors)
end

return M
