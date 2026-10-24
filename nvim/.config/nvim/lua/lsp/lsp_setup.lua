local M = {}

M.setup = function()
	vim.diagnostic.config({
		virtual_text = false,

		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.INFO] = "",
			},
         [vim.diagnostic.severity.HINT] = "",
			-- optionally, you can also set priority / numhl / linehl:
			-- numhl = { [vim.diagnostic.severity.ERROR] = "DiagnosticError" },
			-- linehl = {},
		},

		update_in_insert = true,
		underline = true,
		severity_sort = true,

		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "if_many",
			header = "",
			prefix = "",
		},
	})
end

M.capabilities = function()
	local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if not ok then
		return vim.lsp.protocol.make_client_capabilities()
	end

	return cmp_nvim_lsp.default_capabilities()
end

M.get_opts = function()
	return {
		capabilities = M.capabilities(),
		flags = { debounce_text_changes = 150 },
	}
end

return M
