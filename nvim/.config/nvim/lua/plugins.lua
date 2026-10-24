local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Use a  protected call avoids errors on first calls
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup({
	function(use)
		use("wbthomason/packer.nvim")

      -- mcp server 
      
      use {
    'ravitemer/mcphub.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    -- Installs the Node backend required to manage MCP servers
    run = 'npm install -g mcp-hub@latest',
    config = function()
      require('mcphub').setup({
        -- Configuration options if needed
      })
    end,
  }

		--  User interface
		use({ "akinsho/bufferline.nvim", tag = "*", requires = "kyazdani42/nvim-web-devicons" })
		use({
			"kyazdani42/nvim-tree.lua",
			"kyazdani42/nvim-web-devicons", -- optional, for file icons
			requires = {},
			-- removed nightly seeing issue with fugitive
			tag = "nightly", -- optional, updated every week.
		})

		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
		})

		-- Navigation
		use({
			"nvim-telescope/telescope.nvim",
			requires = { { "nvim-lua/plenary.nvim" } },
		})

		-- Find and Replace

		use({
			"nvim-pack/nvim-spectre",
			requires = { { "nvim-lua/plenary.nvim" } },
		})

		--  completion
		use("hrsh7th/nvim-cmp") -- The completion plugin
		use("hrsh7th/cmp-buffer") -- buffer completions
		use("hrsh7th/cmp-path") -- path completions
		use("hrsh7th/cmp-cmdline") -- cmdline completions
		use("saadparwaiz1/cmp_luasnip") -- snippet completions
		use("hrsh7th/cmp-nvim-lsp")

		-- copilot
		use("github/copilot.vim")

		-- snippets
		use("L3MON4D3/LuaSnip") --snippet engine
		use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

		-- language specific
		use("averms/black-nvim")
		use("mhinz/vim-mix-format")
		use("evanleck/vim-svelte")
	   use("elixir-editors/vim-elixir")
		-- language specific: Dart & Flutter (not using)
		--   use 'dart-lang/dart-vim-plugin'
		--   use 'thosakwe/vim-flutter'

		-- use { 'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim' }

		-- Language specific: Markdown preview

		use({
			"iamcco/markdown-preview.nvim",
			run = function()
				vim.fn["mkdp#util#install"]()
			end,
			cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
			ft = { "markdown" },
		})

		-- REPL
		-- use 'bfredl/nvim-ipy'

		-- keybinds
		use("folke/which-key.nvim")

		-- syntax & lang server
		use({
			"nvim-treesitter/nvim-treesitter",
			branch = "main",
			run = ":TSUpdate",
		})

		--- Navigation using treesitter
		use({
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
			after = "nvim-treesitter",
			requires = "nvim-treesitter/nvim-treesitter",
		})

		--  utils
		use("tpope/vim-fugitive")
		use("tpope/vim-surround")
		use("tpope/vim-eunuch")
		use("windwp/nvim-autopairs")

		-- LSP
		use("neovim/nvim-lspconfig") -- enable LSP
		use("williamboman/mason.nvim")
		use("williamboman/mason-lspconfig.nvim")

		use({
			"nvimtools/none-ls.nvim",
			requires = { "nvimtools/none-ls-extras.nvim" },
		})

		-- Debug
		use("mfussenegger/nvim-dap")

		-- theme
		use("EdenEast/nightfox.nvim")

		if PACKER_BOOTSTRAP then
			require("packer").sync()
		end
	end,
})
