vim.o.background = "dark"
vim.cmd("set notermguicolors")
vim.cmd("colorscheme duskfox")

 -- NOTE: This is a workaround for the issue where treesitter highlights do not enable automatically (notabily with elixir and ruby)
 -- local augroup = vim.api.nvim_create_augroup("TShighlight", { clear = true })

 -- vim.api.nvim_create_autocmd("VimEnter", {
 --   group = augroup,
 --   pattern = "*",
 --   command = "TSEnable highlight",
 -- })

