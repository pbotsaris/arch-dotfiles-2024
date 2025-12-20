local status_ok, wk = pcall(require, "which-key")
if not status_ok then
   return
end

wk.setup({
   preset = "classic",
   spelling = { enabled = true, suggestions = 20 },
   win = { border = "single" },
   -- hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
   show_help = true, -- show help message on the command line when the popup is visible
   triggers = "auto", -- automatically setup triggers
})

local opts = {
   mode = "n",
   prefix = "<leader>",
   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
   silent = true,
   noremap = true,
   nowait = true,
}

wk.add({
   { "<leader>w", "<cmd>w!<cr>",                                            desc = "save file" },
   { "<leader>q", "<cmd>q<cr>",                                             desc = "quit" },
   { "<leader>f", "<cmd>lua require('telescope.builtin').find_files()<CR>", desc = "Telescope files" },
   { "<leader>s", "<cmd>lua require('telescope.builtin').git_files()<CR>",  desc = "Telescope Git Files" },
   { "<leader>g", "<cmd>lua require('telescope.builtin').live_grep()<CR>",  desc = "Telescope grep" },
   { "<leader>b", "<cmd>lua require('telescope.builtin').buffers()<CR>",    desc = "Telescope buffers" },
   { "<leader>k", "<cmd>Telescope keymaps<cr>",                             desc = "Telescope Keymaps" },
   { "<leader>+", ":resize .(winheight(0) * 3/2)<CR>",                      desc = "resize +" },
   { "<leader>-", ":resize .(winheight(1) * 2/3)<CR>",                      desc = "reseize -" },
   { "<leader>n", ":NvimTreeToggle<CR>",                                    desc = "Open explorer" },
   { "<leader>t", ":sp<CR> :term<CR> :resize 20N<CR> i",                    desc = "Open terminal" },
   { "<leader>h", ":sp<CR>",                                                desc = "Horizontal split" },
   { "<leader>v", ":vs<CR>",                                                desc = "Vertical split" },
   { "<leader>m", "<cmd>lua vim.lsp.buf.format()<CR>",                      desc = "Format" },
   }, opts)
