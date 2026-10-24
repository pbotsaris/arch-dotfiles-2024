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

local lsp_setup = require("lsp.lsp_setup")

-- servers to install and enable (nvim-lspconfig names); lua/lsp/settings/<server>.lua is applied when it exists
local servers = {
	"clangd",
	"cssls",
	"dexter",
	"expert",
	"gopls",
	"html",
	"jsonls",
	"lua_ls",
	"pyright",
	"rubocop",
	"solargraph",
	"sqls",
	"svelte",
	"tailwindcss",
	"taplo",
	"ts_ls",
	"zls",
}

-- competing elixir servers: only vim.g.elixir_lsp is enabled, switch at runtime with :LspElixir
local elixir_servers = {
	"expert",
	"dexter",
}

vim.g.elixir_lsp = vim.g.elixir_lsp or "expert"

mason.setup({})

mlc.setup({
	ensure_installed = servers,
	automatic_enable = false,
})

lsp_setup.setup()

-- shared defaults, deep-merged into every server config
vim.lsp.config("*", lsp_setup.get_opts())

local settings_dir = vim.fn.stdpath("config") .. "/lua/lsp/settings"

for _, name in ipairs(servers) do
	local settings_file = settings_dir .. "/" .. name .. ".lua"

	if vim.uv.fs_stat(settings_file) then
		vim.lsp.config(name, dofile(settings_file))
	end

	if vim.tbl_contains(elixir_servers, name) and name ~= vim.g.elixir_lsp then
		goto continue
	end

	vim.lsp.enable(name)

	::continue::
end

-- :LspElixir toggles between the elixir servers, :LspElixir <name> picks one
vim.api.nvim_create_user_command("LspElixir", function(opts)
	local current = vim.g.elixir_lsp
	local target = opts.args

	if target == "" then
		target = vim.iter(elixir_servers):find(function(name)
			return name ~= current
		end)
	end

	if not vim.tbl_contains(elixir_servers, target) then
		vim.notify("unknown elixir lsp: " .. target, vim.log.levels.ERROR)
		return
	end

	if target == current then
		vim.notify("elixir lsp already " .. current)
		return
	end

	vim.lsp.enable(current, false)
	vim.lsp.enable(target)

	vim.g.elixir_lsp = target

	vim.notify("elixir lsp: " .. target)
end, {
	nargs = "?",
	complete = function()
		return elixir_servers
	end,
})

require("lsp.null_ls")
