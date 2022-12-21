local M = {}

-- todo: format and extract functions from use
-- todo: remove . from backupdir

function M.use()
  local ensure_packer = function()
    local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
      vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
      vim.cmd([[packadd packer.nvim]])
      return true
    end
    return false
  end

  local packer_bootstrap = ensure_packer()

  return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")
    if packer_bootstrap then
      require("packer").sync()
    end
  end)
end

return M
