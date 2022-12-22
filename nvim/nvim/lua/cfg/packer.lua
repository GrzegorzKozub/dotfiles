local M = {}

local bootstrap = function()
  local path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if vim.fn.empty(vim.fn.glob(path)) > 0 then
    vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", path })
    vim.cmd.packadd("packer.nvim")
    return true
  end
  return false
end

function M.init()
  return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")

    -- themes
    use("lifepillar/vim-gruvbox8")
    use("lifepillar/vim-solarized8")

    if bootstrap() then
      require("packer").sync()
    end
  end)
end

return M
