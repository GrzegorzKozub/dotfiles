local options = {
  autoindent = true,
  autoread = true,
  backspace = { "indent", "eol", "start" },
  backup = true,
  belloff = "all",
  cursorline = true, -- can break per https://github.com/neovim/neovim/issues/9019
  encoding = "utf-8",
  expandtab = true,
  foldlevelstart = 99,
  foldmethod = "syntax",
  hidden = true,
  history = 1000,
  hlsearch = true,
  ignorecase = true,
  incsearch = true,
  infercase = true,
  joinspaces = false,
  langremap = false,
  laststatus = 2,
  lazyredraw = true,
  listchars = { tab = "→ ", eol = "¬", trail = "·" },
  mouse = "a",
  number = true,
  scrolloff = 3,
  shiftwidth = 2,
  showcmd = true,
  showmatch = true,
  showmode = false,
  sidescroll = 1,
  sidescrolloff = 15,
  smartcase = true,
  smartindent = true,
  smarttab = true,
  softtabstop = 2,
  spelllang = { "en_gb", "pl" },
  splitbelow = true,
  splitright = true,
  swapfile = false,
  tabstop = 2,
  termguicolors = true,
  ttimeout = true,
  ttimeoutlen = 50,
  undofile = true,
  wildmenu = true,
  wildmode = { "longest:full", "full" },
  wildoptions = "tagfile",
  wrap = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.diffopt:append({ "algorithm:histogram", "indent-heuristic", "context:3" })
vim.opt.display:append("lastline")
vim.opt.fillchars:append({ vert = " " })
vim.opt.nrformats:remove("octal")
vim.opt.shortmess:append("I")
vim.opt.whichwrap:append("<,>,[,]")
