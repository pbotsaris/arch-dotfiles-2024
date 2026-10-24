# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Neovim (0.12+) config written in Lua. It lives in a GNU Stow-managed dotfiles repo (`~/dotfiles/nvim/.config/nvim`) and is symlinked to `~/.config/nvim` — both paths are the same files. Stow is run from the dotfiles root via `make` (install/restow) and `make clean` (remove symlinks).

There is no build or test suite. Verify changes by launching Neovim:

- `nvim --headless "+qa"` — check that startup produces no errors
- `:PackerSync` — install/update plugins after editing `lua/plugins.lua`
- `:checkhealth`, `:LspInfo` (custom, defined in `lua/custom-commands.lua`), `:Mason`

## Architecture

- `init.lua` just `require`s each module in order. Every top-level `lua/*.lua` file is a self-contained config for one concern (keymaps, theme, telescope, cmp, etc.). New modules must be added to `init.lua`.
- **Plugin manager: packer.nvim** (`lua/plugins.lua`), self-bootstrapping on first launch. `plugin/packer_compiled.lua` is generated — don't hand-edit it.
- **Keymaps** are split: plain mappings in `lua/keykinds.lua`; `<leader>` (Space) mappings registered through which-key in `lua/which-keys.lua`; completion mappings in `lua/cmp-config.lua`.
- **Treesitter** uses the `main` branch API (`nvim-treesitter.config` / `require("nvim-treesitter").install`), not the legacy `ensure_installed` setup. Parser list is in `lua/treesitter-config.lua`.

### LSP

Uses the native Neovim 0.11+ API (`vim.lsp.config` / `vim.lsp.enable`), not `lspconfig.<server>.setup`.

- **The `servers` list in `lua/lsp/init.lua` is the single source of truth.** Mason installs everything in it (`ensure_installed`) and each entry is enabled with `vim.lsp.enable`. If `lua/lsp/settings/<server>.lua` exists, its returned table is applied with `vim.lsp.config` first. Names are nvim-lspconfig server names (e.g. `jsonls`, `lua_ls`, `ts_ls`). To add a server, add it to the list; to disable one, remove it. Settings files for servers not in the list (e.g. `_not_being_used_elixirls.lua`) are ignored.
- Settings files use the native config shape: `cmd`, `filetypes`, `root_markers`, `settings`, `init_options`. Don't use lspconfig-era keys like `root_dir = util.root_pattern(...)` or `setup = { commands = ... }`.
- Elixir has two competing servers (`expert`, `dexter`); both are installed but only `vim.g.elixir_lsp` (default `expert`) is enabled. `:LspElixir [name]` switches at runtime: `vim.lsp.enable(old, false)` stops its clients, `vim.lsp.enable(new)` attaches to already-open buffers.
- Shared defaults (`cmp-nvim-lsp` capabilities, debounce) come from `lsp_setup.get_opts()` and are applied via `vim.lsp.config("*", ...)`, so they deep-merge into every server; a settings file only needs the fields it overrides. `lsp_setup.lua` also holds the diagnostic config. LSP keymaps are global (`lua/keykinds.lua`), so there is no `on_attach`.
- Formatting/linting goes through none-ls (`lua/lsp/null_ls.lua`); format is manual via `<leader>m` (`vim.lsp.buf.format()`), not on save. `vim.lsp.buf.format()` runs every attached formatter in sequence, so avoid overlapping a none-ls source with an LSP: Elixir formatting comes from the active Elixir LSP and Ruby from the `rubocop` LSP, not none-ls. Credo runs on save only, and only when the project's `mix.lock` includes credo.
