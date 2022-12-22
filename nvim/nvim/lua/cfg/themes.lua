local M = {}

local function normalize_colorscheme(wanted)
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
  local _, _, colorscheme, background = string.find(vim.env.MY_THEME or "", "([%a%d]+)%-([%a%d]+)")
  return normalize_colorscheme(colorscheme), normalize_background(background)
end

function M.init()
  local colorscheme, background = theme()
  vim.opt.background = background
  vim.cmd.colorscheme(colorscheme)
end

return M
