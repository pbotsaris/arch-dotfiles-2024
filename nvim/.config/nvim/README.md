# Neovim config

Lua config for Neovim 0.12+, installed with GNU Stow from `~/dotfiles` (`make`), which links it to `~/.config/nvim`.

## Stack

- **Plugins:** packer.nvim, which installs itself on first launch. Run `:PackerSync` after editing `lua/plugins.lua`.
- **LSP:** native `vim.lsp.config` / `vim.lsp.enable`, with servers installed by Mason.
- **Formatting / linting:** none-ls (prettier, black, clang-format, stylua, credo, …).
- **UI:** nightfox, lualine, bufferline, nvim-tree, telescope, which-key, treesitter (`main` branch).

## LSP

- Add a server to the `servers` list in `lua/lsp/init.lua`. Mason installs it and it's enabled on the next start.
- Put per-server settings in `lua/lsp/settings/<server>.lua`. They're applied when the file exists.
- Elixir: `expert` or `dexter`, one at a time. `:LspElixir` toggles between them, and `:LspElixir <name>` picks one.

## Keys

Leader is `Space`. Press it to see the which-key menu.

| Key | Action |
| --- | --- |
| `<leader>f` / `g` / `b` | Find files / grep / buffers |
| `<leader>n` | File tree |
| `<leader>m` | Format |
| `<leader>c` / `rn` | Code action / rename |
| `gd` / `gr` / `K` | Definition / references / hover |
| `<C-b>` / `<C-c>` | Debugger: toggle breakpoint / continue |
