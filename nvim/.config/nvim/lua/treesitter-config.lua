-- Install parsers (replaces ensure_installed)
local installed = require("nvim-treesitter.config").get_installed()

local ensure_installed = {
	"c",
	"cpp",
	"zig",
	"lua",
	"rust",
	"javascript",
	"typescript",
	"tsx",
	"go",
	"make",
	"eex",
	"elixir",
	"erlang",
	"heex",
	"html",
	"surface",
	"ruby",
	"python",
}
local to_install = vim.iter(ensure_installed)
	:filter(function(parser)
		return not vim.tbl_contains(installed, parser)
	end)
	:totable()
if #to_install > 0 then
	require("nvim-treesitter").install(to_install)
end

-- Enable treesitter highlighting and indentation via FileType autocmd.
-- Note: we can't key the autocmd off `ensure_installed` (parser names) because
-- some filetypes differ from their parser name, e.g. `.jsx` -> filetype
-- `javascriptreact` -> `javascript` parser, `.tsx` -> `typescriptreact` -> `tsx`.
-- Resolving the language from the buffer's filetype covers those cases.
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		local lang = vim.treesitter.language.get_lang(ft) or ft
		if not vim.tbl_contains(require("nvim-treesitter.config").get_installed(), lang) then
			return
		end
		vim.treesitter.start(args.buf)
		vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- Textobjects configuration (packadd needed because packer loads it as opt/ due to `after`)
vim.cmd("packadd nvim-treesitter-textobjects")
require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v", -- charwise
			["@function.outer"] = "V", -- linewise
			["@class.outer"] = "<c-v>", -- blockwise
		},
		include_surrounding_whitespace = true,
	},
	move = {
		set_jumps = true,
	},
})

-- Textobject select keymaps
vim.keymap.set({ "x", "o" }, "af", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end, { desc = "Select inner part of a class region" })
vim.keymap.set({ "x", "o" }, "as", function()
	require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
end, { desc = "Select language scope" })

-- Textobject move keymaps
vim.keymap.set({ "n", "x", "o" }, "]m", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]]", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
end, { desc = "Next class start" })
vim.keymap.set({ "n", "x", "o" }, "]o", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@loop.*", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]s", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
end, { desc = "Next scope" })
vim.keymap.set({ "n", "x", "o" }, "]z", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
end, { desc = "Next fold" })
vim.keymap.set({ "n", "x", "o" }, "]M", function()
	require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "][", function()
	require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[m", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[[", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[M", function()
	require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[]", function()
	require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "]d", function()
	require("nvim-treesitter-textobjects.move").goto_next_start("@conditional.outer", "textobjects")
end)
vim.keymap.set({ "n", "x", "o" }, "[d", function()
	require("nvim-treesitter-textobjects.move").goto_previous_start("@conditional.outer", "textobjects")
end)
