local ok, mason = pcall(require, "mason")
if not ok then
   vim.notify("mason not found", vim.log.levels.ERROR)
   return
end

local ok, mlc = pcall(require, "mason-lspconfig")
if not ok then
   vim.notify("mason-lspconfig not found", vim.log.levels.ERROR)
   return
end

mason.setup({})

mlc.setup({
   automatic_enable = true,
})

require("lsp.lsp_setup").setup()

local servers = mlc.get_installed_servers()
for _, name in ipairs(servers) do
   local has_cfg, cfg = pcall(require, "lsp.settings." .. name)
   local opts = vim.tbl_deep_extend(
      "force",
      require("lsp.lsp_setup").get_opts(),
      (has_cfg and cfg) or {}
   )
   vim.lsp.config(name, opts)
end

require("lsp.null_ls")
