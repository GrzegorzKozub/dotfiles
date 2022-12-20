local opts = {
  showmode = false,
}

for k, v in pairs(opts) do
  vim.opt[k] = v
end
