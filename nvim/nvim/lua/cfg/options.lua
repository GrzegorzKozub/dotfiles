local M = {}

function M.init()
  local options = {
    backup = true,
    cursorline = true, -- can break per https://github.com/neovim/neovim/issues/9019
    expandtab = true,
    foldlevelstart = 99,
    foldmethod = "syntax",
    ignorecase = true,
    infercase = true,
    lazyredraw = true,
    listchars = { tab = "→ ", eol = "¬", trail = "·" },
    mouse = "a",
    number = true,
    scrolloff = 3,
    shiftwidth = 2,
    showmatch = true,
    showmode = false,
    sidescrolloff = 15,
    smartcase = true,
    smartindent = true,
    softtabstop = 2,
    spelllang = { "en_gb", "pl" },
    splitbelow = true,
    splitright = true,
    swapfile = false,
    tabstop = 2,
    termguicolors = true,
    undofile = true,
    wildmode = { "longest:full", "full" },
    wildoptions = "tagfile",
    wrap = false,
  }

  for k, v in pairs(options) do
    vim.opt[k] = v
  end

  vim.opt.backupdir:remove(".");
  vim.opt.diffopt:append({ "algorithm:histogram", "indent-heuristic", "context:3" })
  vim.opt.fillchars:append({ vert = " " })
  vim.opt.shortmess:append("I")
  vim.opt.whichwrap:append("<,>,[,]")

  vim.cmd.language(vim.fn.has("win32") == 1 and "English_US" or "en_US.utf8")
end

return M
